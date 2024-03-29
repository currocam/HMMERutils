structure(list(
    url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
    status_code = 400L, headers = structure(list(
        server = "Apache/2.4.6 (CentOS)",
        vary = "Content-Type", `cache-control` = "max-age=0",
        `content-type` = "application/json", `strict-transport-security` = "max-age=0",
        date = "Sun, 23 Oct 2022 16:29:42 GMT", `access-control-max-age` = "1000",
        expires = "Sun, 23 Oct 2022 16:29:42 GMT", `access-control-allow-origin` = "*",
        connection = "close", `set-cookie` = "REDACTED", `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
        `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
        `content-length` = "50"
    ), class = c("insensitive", "list")), all_headers = list(list(
        status = 400L, version = "HTTP/1.1",
        headers = structure(list(
            server = "Apache/2.4.6 (CentOS)",
            vary = "Content-Type", `cache-control` = "max-age=0",
            `content-type` = "application/json", `strict-transport-security` = "max-age=0",
            date = "Sun, 23 Oct 2022 16:29:42 GMT", `access-control-max-age` = "1000",
            expires = "Sun, 23 Oct 2022 16:29:42 GMT", `access-control-allow-origin` = "*",
            connection = "close", `set-cookie` = "REDACTED",
            `access-control-allow-methods` = "HEAD, POST, GET, OPTIONS, DELETE, PUT",
            `access-control-allow-headers` = "x-requested-with, Content-Type, origin, authorization, accept, client-security-token",
            `content-length` = "50"
        ), class = c(
            "insensitive",
            "list"
        ))
    )), cookies = structure(list(
        domain = "#HttpOnly_www.ebi.ac.uk",
        flag = FALSE, path = "/", secure = FALSE, expiration = structure(1667233782, class = c(
            "POSIXct",
            "POSIXt"
        )), name = "hmmerserver_session", value = "REDACTED"
    ), row.names = c(
        NA,
        -1L
    ), class = "data.frame"), content = charToRaw("{\"hmmdb\":[\"pdb is not a supported hmm database.\"]}"),
    date = structure(1666542582, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
        redirect = 0, namelookup = 5.4e-05,
        connect = 5.4e-05, pretransfer = 0.000186, starttransfer = 0.000189,
        total = 0.072083
    )
), class = "response")
