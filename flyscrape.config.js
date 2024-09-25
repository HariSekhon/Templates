//  [% VIM_TAGS %]
//
//  Author: Hari Sekhon
//  Date: [% DATE # 2008-10-20 16:20:20 +0100 (Mon, 20 Oct 2008) %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

export const config = {

  // follows redirects eg. to https://news.ycombinator.com
  url: "https://hackernews.com",

  // Enable rendering with headless browser.             (default = false)
  //browser: true,

  // Specify if browser should be headless or not.       (default = true)
  //headless: false,

  // Specify the multiple URLs to start scraping from.   (default = [])
  // urls: [
  //     "https://anothersite.com/",
  //     "https://yetanother.com/",
  // ],

  // Specify how deep links should be followed.          (default = 0, no follow)
  // depth: 5,

  // Speficy the css selectors to follow.                (default = ["a[href]"])
  // follow: [".next > a", ".related a"],

  // Specify the allowed domains. ['*'] for all.         (default = domain from url)
  // allowedDomains: ["example.com", "anothersite.com"],

  // Specify the blocked domains.                        (default = none)
  // blockedDomains: ["somesite.com"],

  // Specify the allowed URLs as regex.                  (default = all allowed)
  // allowedURLs: ["/posts", "/articles/\d+"],

  // Specify the blocked URLs as regex.                  (default = none)
  // blockedURLs: ["/admin"],

  // Specify the rate in requests per minute.            (default = no rate limit)
  // rate: 60,

  // Specify the number of concurrent requests.          (default = no limit)
  // concurrency: 1,

  // Specify a single HTTP(S) proxy URL.                 (default = no proxy)
  // Note: Not compatible with browser mode.
  // proxy: "http://someproxy.com:8043",

  // Specify multiple HTTP(S) proxy URLs.                (default = no proxy)
  // Note: Not compatible with browser mode.
  // proxies: [
  //   "http://someproxy.com:8043",
  //   "http://someotherproxy.com:8043",
  // ],

  // XXX: use this in development mode to not have to repeatedly request the page
  // Enable file-based request caching.                  (default = no cache)
  cache: "file",

  // Specify the HTTP request header.                    (default = none)
  // headers: {
  //     "Authorization": "Bearer ...",
  //     "User-Agent": "Mozilla ...",
  // },

  // Use the cookie store of your local browser.         (default = off)
  // XXX: use this for sites that require being logged in
  // Options: "chrome" | "edge" | "firefox"
  // cookies: "chrome",

  // Specify the output options.
  // output: {
  //     // Specify the output file.                        (default = stdout)
  //     file: "results.json",
  //
  //     // Specify the output format.                      (default = json)
  //     // Options: "json" | "ndjson"
  //     format: "json",
  // },
};

export default function({ doc, absoluteURL }) {
  const title = doc.find("h1");
  //const link = doc.find("a");
  const posts = doc.find(".athing");

  return {
    title: title.text(),
	posts: posts.map((post) => {
        const link = post.find(".titleline > a");
        const meta = post.next();

        return {
          title: link.text(),
          url: absoluteURL(link.attr("href")),
          user: meta.find(".hnuser").text(),
        };
    }),
    //link: {
    //  text: link.text(),
    //  url: absoluteURL(link.attr("href")),
    //},
  };
}
