test_that("local (i.e. no database reference) works", {
  parse_fasta_headers(
    c(
      "lcl|123",
      "lcl|hmm271 description"
    )
  ) %>%
    expect_equal(
      c(
        "123",
        "hmm271"
      )
    )
})
test_that("GenInfo backbone seqid  works", {
  parse_fasta_headers(
    c(
      "bbs|123 ",
      "bbs|123 "
    )
  ) %>%
    expect_equal(
      c(
        "123",
        "123"
      )
    )
})
test_that("GenInfo backbone moltype   works", {
  parse_fasta_headers(
    c(
      "bbm|123",
      "bbm|123 "
    )
  ) %>%
    expect_equal(
      c(
        "123",
        "123"
      )
    )
})
test_that("GenInfo import ID  works", {
  parse_fasta_headers(
    c(
      "gim|123",
      "gim|123"
    )
  ) %>%
    expect_equal(
      c(
        "123",
        "123"
      )
    )
})
test_that("GenBank works", {
  parse_fasta_headers(
    c(
      "gb|M73307|AGMA13GT",
      "gb|M73307|AGMA13GT"
    )
  ) %>%
    expect_equal(
      c(
        "M73307",
        "M73307"
      )
    )
})
test_that("EMBL works", {
  parse_fasta_headers(
    c(
      "emb|CAM43271.1|",
      "emb|CAM43271.1|"
    )
  ) %>%
    expect_equal(
      c(
        "CAM43271.1",
        "CAM43271.1"
      )
    )
})
test_that("PIR works", {
  parse_fasta_headers(
    c(
      "pir||G36364",
      "pir||G36364"
    )
  ) %>%
    expect_equal(
      c(
        "G36364",
        "G36364"
      )
    )
})
test_that("SWISS-PROT works", {
  parse_fasta_headers(
    c(
      "sp|P01013|OVAX_CHICK",
      "sp|P01013|OVAX_CHICK description"
    )
  ) %>%
    expect_equal(
      c(
        "OVAX_CHICK",
        "OVAX_CHICK"
      )
    )
})
test_that("patent works", {
  parse_fasta_headers(
    c(
      "pat|US|RE33188|1",
      "pat|US|RE33188|1"
    )
  ) %>%
    expect_equal(
      c(
        "RE33188",
        "RE33188"
      )
    )
})
test_that("pre-grant patent  works", {
  parse_fasta_headers(
    c(
      "pgp|EP|0238993|7",
      "pgp|EP|0238993|7"
    )
  ) %>%
    expect_equal(
      c(
        "0238993",
        "0238993"
      )
    )
})
test_that("RefSeq works", {
  parse_fasta_headers(
    c(
      "ref|NM_010450.1|",
      "ref|NM_010450.1|"
    )
  ) %>%
    expect_equal(
      c(
        "NM_010450.1",
        "NM_010450.1"
      )
    )
})
test_that("general database referenceworks ", {
  parse_fasta_headers(
    c(
      "gnl|taxon|9606",
      "gnl|PID|e1632"
    )
  ) %>%
    expect_equal(
      c(
        "9606",
        "e1632"
      )
    )
})
test_that("GenInfo integrated database  works", {
  parse_fasta_headers(
    c(
      "gi|21434723",
      "gi|21434723"
    )
  ) %>%
    expect_equal(
      c(
        "21434723",
        "21434723"
      )
    )
})
test_that("DDBJworks", {
  parse_fasta_headers(
    c(
      "dbj|BAC85684.1|",
      "dbj|BAC85684.1|"
    )
  ) %>%
    expect_equal(
      c(
        "BAC85684.1",
        "BAC85684.1"
      )
    )
})
test_that("PRF works", {
  parse_fasta_headers(
    c(
      "prf||0806162C",
      " prf||0806162C"
    )
  ) %>%
    expect_equal(
      c(
        "0806162C",
        "0806162C"
      )
    )
})
test_that("pdb works", {
  parse_fasta_headers(
    c(
      "pdb|1I4L|D",
      "pdb|1I4L|D"
    )
  ) %>%
    expect_equal(
      c(
        "1I4L_D",
        "1I4L_D"
      )
    )
})
test_that("third-party GenBank works", {
  parse_fasta_headers(
    c(
      "tpg|BK003456|",
      "tpg|BK003456|"
    )
  ) %>%
    expect_equal(
      c(
        "BK003456",
        "BK003456"
      )
    )
})
test_that("third-party EMBL works", {
  parse_fasta_headers(
    c(
      "tpe|BN000123|",
      "tpe|BN000123|"
    )
  ) %>%
    expect_equal(
      c(
        "BN000123",
        "BN000123"
      )
    )
})
test_that("third-party DDBJ works", {
  parse_fasta_headers(
    c(
      "tpd|FAA00017|",
      "tpd|FAA00017|"
    )
  ) %>%
    expect_equal(
      c(
        "FAA00017",
        "FAA00017"
      )
    )
})
test_that("TrEMBL works", {
  parse_fasta_headers(
    c(
      "tr|Q90RT2|Q90RT2_9HIV1",
      "tr|Q90RT2|Q90RT2_9HIV1"
    )
  ) %>%
    expect_equal(
      c(
        "Q90RT2_9HIV1",
        "Q90RT2_9HIV1"
      )
    )
})