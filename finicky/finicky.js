const firefox = {
  name: "org.mozilla.firefox",
  openInBackground: false,
};

const _firefox = (container) => {
  const browser = { ...firefox };
  browser.container = container;
  return browser;
};

const firefoxZsu = _firefox("Zsu");

// const firefoxZsuDev = _firefox("ZsuDev");

const firefoxPersonal = _firefox("Personal");

const firefoxProton = _firefox("Proton");

const chromeKulynyak = {
  name: "com.google.Chrome",
  profile: "kulynyak",
  openInBackground: false,
};

const chromeZsu = {
  name: "com.google.Chrome",
  profile: "zsu",
  openInBackground: false,
};

// const chromeZsuDev = {
//   name: "com.google.Chrome",
//   profile: "zsu-dev",
//   openInBackground: false,
// };

const safari = {
  name: "com.apple.Safari",
  openInBackground: false,
};

const browsers = {
  personal: firefoxPersonal,
  proton: firefoxProton,
  zsu: firefoxZsu,
  // zsuDev: firefoxZsuDev,
  work: chromeZsu,
  uiZsu: chromeZsu,
  // uiZsuDev: chromeZsuDev,
  kulynyak: chromeKulynyak,
  safari: safari,
  teams: {
    name: "com.microsoft.teams2",
    openInBackground: false,
  },
  zoom: {
    name: "us.zoom.xos",
    openInBackground: false,
  },
  appleMusic: {
    name: "com.apple.Music",
    openInBackground: false,
  },
  telegram: {
    name: "ru.keepcoder.Telegram",
    openInBackground: false,
  },
  figma: {
    name: "com.figma.Desktop",
    openInBackground: false,
  },
};

const parseQueryParams = (queryString) => {
  const params = {};
  const query = queryString.startsWith("?") ? queryString.slice(1) : queryString;
  query.split("&").forEach((pair) => {
    const [key, value] = pair.split("=");
    if (key) {
      params[key] = decodeURIComponent(value || "");
    }
  });
  return params;
};

const parseCustomUrl = (urlString) => {
  // Updated regex to capture the port if available and handle the port as a number or null
  const a = urlString.match(/^(https?):\/\/([^\/:]+)(?::(\d+))?(\/[^\?#]*)?(\?[^#]*)?(#.*)?$/);
  if (!a) {
    finicky.log("Error: URL string is not parsed", urlString);
    return null; // Invalid URL format
  }
  const [, protocol, host, port, pathname, search, hash] = a;
  // Convert port to a number or null if not provided
  const parsedPort = port ? parseInt(port, 10) : null;
  return {
    protocol: protocol || "",
    host: host || "",
    port: parsedPort, // Return port as number or null
    pathname: pathname || "",
    search: search || "",
    hash: hash || "",
  };
};

const isFirefoxContainer = (browser) => {
  return browser.hasOwnProperty("container");
};

const getFirefoxContainer = (browser) => {
  return browser.hasOwnProperty("container") ? browser.container : null;
};

const packUrlStringToFFContainer = (container, urlString) => {
  urlString = container !== null ? `ext+container:name=${container}&url=${encodeURIComponent(urlString)}` : urlString;
  // finicky.log("Packed URL:", urlString);
  return urlString;
};

const getBrowser = (browser) => {
  const result = {
    name: browser.name,
    openInBackground: browser.openInBackground,
    profile: browser.profile,
  };
  // finicky.log("Browser:", JSON.stringify(result, null, 2));
  return result;
};

const matchesRegex = (text, ...patterns) => {
  const txt = decodeURIComponent(text);
  // Flatten patterns array if needed
  const flatPatterns = patterns.flat();
  return flatPatterns.some((pattern) => {
    finicky.log("txt: ", txt, "pattern: ", pattern);
    if (typeof pattern === "string") {
      const result = txt.includes(pattern); // Compare txt with pattern (decoded value)
      // finicky.log("result: ", result, "str pattern: ", pattern);
      return result;
    }
    if (pattern instanceof RegExp) {
      const result = pattern.test(txt); // Ensure "result" is declared
      // finicky.log("result: ", result, "reg pattern: ", pattern);
      return result;
    }
    // If pattern is neither a string nor a RegExp, ignore it
    // finicky.log("no match for: ", txt);
    return false;
  });
};

const getRewriteRule = (rule) => {
  return {
    match: ({ urlString }) => matchesRegex(urlString, rule.regexp),
    url: ({ urlString }) => {
      return packUrlStringToFFContainer(getFirefoxContainer(rule.browser), urlString);
    },
  };
};

const getHandlerRule = (rule) => {
  return {
    match: ({ urlString }) => matchesRegex(urlString, rule.regexp),
    browser: getBrowser(rule.browser),
  };
};

const appendRewriteRules = (rewriteRules, browserRules) => {
  for (let rule of browserRules) {
    if (isFirefoxContainer(rule.browser)) {
      rewriteRules.push(getRewriteRule(rule));
    }
  }
  // finicky.log("Rewrite rules:", JSON.stringify(rewriteRules, null, 2));
  return rewriteRules;
};
const appendHandlerRules = (handlerRules, browserRules) => {
  for (let rule of browserRules) {
    handlerRules.push(getHandlerRule(rule));
  }
  // finicky.log("Handler rules:", JSON.stringify(handlerRules, null, 2));
  return handlerRules;
};

const browserRules = [
  {
    browser: browsers.proton,
    regexp: [/tailscale\.com/, /protonmail\.com/, /proton\.me/],
  },
  {
    browser: browsers.work,
    regexp: [/github\.com\/gtacontur\//, /(chat|meet)\.google\.com/],
  },
  // {
  //   browser: browsers.uiZsuDev,
  //   regexp: [/stg\.delta\.mil\.gov\.ua/],
  // },
  {
    browser: browsers.uiZsu,
    regexp: [/mil(\.gov)*\.ua/],
  },
  {
    browser: browsers.zsu,
    regexp: [
      /lab\.volvo\.mito/,
      /karmf\.net/,
      /oak\.in\.ua/,
      /mq\.eu-central-1\.amazonaws\.com/,
      /forms\.office\.com/,
      /green-house-corp\.atlassian\.net/,
      /id\.atlassian\.com/,
      /github\.com(\/org)*(\/(vezhadev|gtakontur)\/)/,
      /grafana\..*\/explore/,
      /data\..*\/graphql\//,
    ],
  },
  {
    browser: browsers.personal,
    regexp: [/youtube\.com/, /maps\.google\.com/],
  },
];

const rewriteRules = [
  {
    // Redirect all urls to use https
    match: ({ url }) => url.protocol === "http",
    url: { protocol: "https" },
  },
  {
    // Extract the url from MS Teams links
    match: (opts) => {
      // finicky.log("Options:", JSON.stringify(opts, null, 2));
      return opts.opener.bundleId === "com.microsoft.teams2";
    },
    url: ({ url }) => {
      const params = parseQueryParams(url.search);
      const urlParam = params["url"];
      if (!urlParam) {
        finicky.log("Error: url param empty", url.search);
        return url;
      }
      const xUrl = decodeURIComponent(urlParam);
      const customUrl = parseCustomUrl(xUrl);
      // finicky.log("New URL:", JSON.stringify(customUrl, null, 2));
      return customUrl;
    },
  },
  {
    match: ({ url }) => url.host.includes("zoom.us") && url.pathname.includes("/j/"),
    url({ url }) {
      try {
        var pass = "&pwd=" + url.search.match(/pwd=(\w*)/)[1];
      } catch {
        var pass = "";
      }
      var conf = "confno=" + url.pathname.match(/\/j\/(\d+)/)[1];
      return {
        search: conf + pass,
        pathname: "/join",
        protocol: "zoommtg",
      };
    },
  },
];

const handlerRules = [
  {
    // dummy
    match: (opts) => {
      // finicky.log("Options:", JSON.stringify(opts, null, 2));
      return false;
    },
    browser: getBrowser(browsers.personal),
  },
  {
    match: [/(apple|icloud)\.com/],
    browser: getBrowser(browsers.safari),
  },
  {
    // Open MS Teams urls in the MS Teams app
    match: finicky.matchHostnames("teams.microsoft.com"),
    browser: getBrowser(browsers.teams),
    url: ({ url }) => ({ ...url, protocol: "msteams" }),
  },
  {
    // Open Zoom urls in the Zoom app
    match: /zoom\.us\/join/,
    browser: getBrowser(browsers.zoom),
  },
  {
    // Open Apple Music links directly in Music app
    match: ({ url }) => url.host.endsWith("music.apple.com"),
    url: {
      protocol: "itmss",
    },
    browser: getBrowser(browsers.appleMusic),
  },
  {
    // Open Telegram links directly in Telegram app
    match: finicky.matchHostnames("t.me"),
    url: {
      protocol: "tg",
    },
    browser: getBrowser(browsers.telegram),
  },
  {
    // Open Figma links directly in Figma app
    match: "https://www.figma.com/file/*",
    browser: getBrowser(browsers.figma),
  },
];

module.exports = {
  defaultBrowser: getBrowser(browsers.personal),
  rewrite: appendRewriteRules(rewriteRules, browserRules),
  handlers: appendHandlerRules(handlerRules, browserRules),
};
