package("simple_http")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/fantasy-peak/simple_http")
    set_description("A header-only HTTP library that supports both HTTP/2 and HTTP/1, based on Beast, nghttp2, and Asio.")
    set_license("MIT")

    add_urls("https://github.com/erikPeng123/simple_http.git")

    add_deps("cmake")
    add_deps("boost", {configs = {cmake = false}})
    add_deps("nghttp2", "openssl")

    on_install("linux", "cross", "bsd", function (package)
        import("package.tools.cmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            simple_http::Config cfg{.ip = "0.0.0.0",
                                    .port = 6666,
                                    .worker_num = 4,
                                    .concurrent_streams = 200};
            void test() {
                simple_http::HttpServer hs(cfg);
                hs.setHttpHandler("/hello", [](auto req, auto writer) -> boost::asio::awaitable<void> { co_return; });
                return;
            }
        ]]}, {configs = {languages = "c++20"}, includes = {"simple_http.h"}}))
    end)
