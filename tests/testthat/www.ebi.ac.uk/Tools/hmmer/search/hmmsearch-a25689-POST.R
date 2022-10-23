structure(list(
    url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmsearch",
    status_code = 400L, headers = structure(list(
        server = "Apache/2.4.6 (CentOS)",
        vary = "Content-Type", `cache-control` = "max-age=0",
        `content-type` = "application/json", `strict-transport-security` = "max-age=0",
        date = "Sun, 23 Oct 2022 10:21:49 GMT", `access-control-max-age` = "1000",
        expires = "Sun, 23 Oct 2022 10:21:49 GMT", `access-control-allow-origin` = "*",
        connection = "close", `set-cookie` = "REDACTED", `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
        `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
        `content-length` = "140"
    ), class = c("insensitive", "list")), all_headers = list(list(
        status = 400L, version = "HTTP/1.1",
        headers = structure(list(
            server = "Apache/2.4.6 (CentOS)",
            vary = "Content-Type", `cache-control` = "max-age=0",
            `content-type` = "application/json", `strict-transport-security` = "max-age=0",
            date = "Sun, 23 Oct 2022 10:21:49 GMT", `access-control-max-age` = "1000",
            expires = "Sun, 23 Oct 2022 10:21:49 GMT", `access-control-allow-origin` = "*",
            connection = "close", `set-cookie` = "REDACTED",
            `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
            `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
            `content-length` = "140"
        ), class = c(
            "insensitive",
            "list"
        ))
    )), cookies = structure(list(
        domain = "#HttpOnly_www.ebi.ac.uk",
        flag = FALSE, path = "/", secure = FALSE, expiration = structure(1667211709, class = c(
            "POSIXct",
            "POSIXt"
        )), name = "hmmerserver_session", value = "REDACTED"
    ), row.names = c(
        NA,
        -1L
    ), class = "data.frame"), content = charToRaw("{\"seq\":[\"Your alignment does not contain two or more aligned sequences. If you are searching only a single sequence, please use phmmer.\\n\"]}"),
    date = structure(1666520509, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
        redirect = 0, namelookup = 0.038037,
        connect = 0.082436, pretransfer = 0.136461, starttransfer = 0.136462,
        total = 0.506644
    )
), class = "response")
