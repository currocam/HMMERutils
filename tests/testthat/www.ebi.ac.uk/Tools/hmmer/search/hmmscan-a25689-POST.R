structure(list(
    url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
    status_code = 400L, headers = structure(list(
        server = "Apache/2.4.6 (CentOS)",
        vary = "Content-Type", `cache-control` = "max-age=0",
        `content-type` = "application/json", `strict-transport-security` = "max-age=0",
        date = "Sun, 23 Oct 2022 10:20:47 GMT", `access-control-max-age` = "1000",
        expires = "Sun, 23 Oct 2022 10:20:47 GMT", `access-control-allow-origin` = "*",
        connection = "close", `set-cookie` = "REDACTED", `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
        `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
        `content-length` = "118"
    ), class = c("insensitive", "list")), all_headers = list(list(
        status = 400L, version = "HTTP/1.1",
        headers = structure(list(
            server = "Apache/2.4.6 (CentOS)",
            vary = "Content-Type", `cache-control` = "max-age=0",
            `content-type` = "application/json", `strict-transport-security` = "max-age=0",
            date = "Sun, 23 Oct 2022 10:20:47 GMT", `access-control-max-age` = "1000",
            expires = "Sun, 23 Oct 2022 10:20:47 GMT", `access-control-allow-origin` = "*",
            connection = "close", `set-cookie` = "REDACTED",
            `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
            `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
            `content-length` = "118"
        ), class = c(
            "insensitive",
            "list"
        ))
    )), cookies = structure(list(
        domain = "#HttpOnly_www.ebi.ac.uk",
        flag = FALSE, path = "/", secure = FALSE, expiration = structure(1667211647, class = c(
            "POSIXct",
            "POSIXt"
        )), name = "hmmerserver_session", value = "REDACTED"
    ), row.names = c(
        NA,
        -1L
    ), class = "data.frame"), content = charToRaw("{\"seqdb\":[\"Both target sequence and hmm databases defined. Please choose only an hmm database for use with hmmscan.\"]}"),
    date = structure(1666520447, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
        redirect = 0, namelookup = 0.060747,
        connect = 0.095144, pretransfer = 0.194322, starttransfer = 0.194323,
        total = 0.291425
    )
), class = "response")
