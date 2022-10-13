'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "924ebcf988218f44071cfe281d9235d8",
"splash/style.css": "cbfe62a2c7e6af0e29b484d30610f3cf",
"splash/img/dark-4x.png": "3872fcfbfee59fdc95d1e94b885c0e8f",
"splash/img/dark-1x.png": "04959c8d602e924c37f5fbc55e69af2c",
"splash/img/light-1x.png": "ab1cbcce80981cd3e51785e663fad95b",
"splash/img/branding-dark-1x.png": "97d64ef0611da1140aeedc770fb5ef66",
"splash/img/branding-dark-4x.png": "3b516d5c0997a1b30b2a97ead2a14734",
"splash/img/branding-3x.png": "9e0adb6598374bce94473d1a35153b95",
"splash/img/light-4x.png": "c14e7d7bdb5f3e95b0c067c5fe71e655",
"splash/img/branding-4x.png": "f20ee9c5723cbf92c03f444942e6c53b",
"splash/img/light-3x.png": "239469b76eda5aeb5e92cc169e889bdb",
"splash/img/dark-3x.png": "ddff9c2afc9ae725ee435dcb5fd89040",
"splash/img/branding-2x.png": "3301fc1091fecd3d665a4604899ac58b",
"splash/img/branding-1x.png": "b69a8b822697c0a2cb8397069c7dc205",
"splash/img/light-2x.png": "c0c5af0227d5e46c5cf7597f49defc8f",
"splash/img/branding-dark-2x.png": "490a323baa9421fc6a5857f733d6dc95",
"splash/img/dark-2x.png": "c24a0febf0d2f939e885abfa291fe7b1",
"splash/img/branding-dark-3x.png": "cb1d0203a8763a47eb93bbb3483782a8",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"index.html": "538ab6b9bac7810280637aac18791b93",
"/": "538ab6b9bac7810280637aac18791b93",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"manifest.json": "f7a4db1eded98196fbe7936ac8c18021",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"assets/AssetManifest.json": "45658a82e77b74934b787f1575bd6a09",
"assets/shaders/ink_sparkle.frag": "0cfae77e432d12ec44627f8d9eacbc65",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/window_manager/images/ic_chrome_maximize.png": "af7499d7657c8b69d23b85156b60298c",
"assets/packages/window_manager/images/ic_chrome_minimize.png": "4282cd84cb36edf2efb950ad9269ca62",
"assets/packages/window_manager/images/ic_chrome_unmaximize.png": "4a90c1909cb74e8f0d35794e2f61d8bf",
"assets/packages/window_manager/images/ic_chrome_close.png": "75f4b8ab3608a05461a31fc18d6b47c2",
"assets/packages/fluent_ui/assets/AcrylicNoise.png": "81f27726c45346351eca125bd062e9a7",
"assets/packages/fluent_ui/fonts/FluentIcons.ttf": "1cd173aed13e298ab2663dd0924f6762",
"assets/FontManifest.json": "0cc815b4a8e40f5e33617b67348fd87d",
"assets/assets/images/dart.png": "735531cda11c098d9eed28ead619ab41",
"assets/assets/images/logo_lockup_flutter_vertical_wht.png": "0bdc069af57528e88f6c6b891ad57b8d",
"assets/assets/images/intro/img1.jpg": "1c11df7b10929fe20cbae60d9e4a068e",
"assets/assets/images/intro/img2.jpg": "53fccaf3108f36c49d25e5b83f81033f",
"assets/assets/images/intro/img3.jpg": "22ed268aacd7667a16c2744dcac42f6f",
"assets/assets/images/intro/flutter.png": "d21f1eecaeaab081ba7efec1721c0712",
"assets/assets/images/intro/fullscreen.jpg": "df5a33671f287160298604d3372b5d85",
"assets/assets/images/logo_lockup_flutter_vertical.png": "ba4b1a14585b212fa1fcb6fce41e647c",
"assets/assets/images/android12splash.png": "1b156e18a51eec7a6c707e7f32f323fb",
"assets/assets/images/dart_dark.png": "bbe3eec92e8132c1fe26422c853b913a",
"assets/assets/fonts/iconfont.ttf": "61ab849333512158c9d47354c641aeec",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "257465354614b0969ef03974e384d643",
"version.json": "404ac7ee9da5da8572940346f863bd6d",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
