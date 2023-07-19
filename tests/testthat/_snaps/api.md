# base request works

    Code
      hmmer_request(algo = "phmmer", seq = "AAACATT", seqdb = "swissprot")
    Message <cliMessage>
      <httr2_request>
      POST https://www.ebi.ac.uk/Tools/hmmer/search/phmmer
      Headers:
      * Accept: 'application/json'
      Body: json encoded data
      Options:
      * useragent: 'HMMERutils (http://github.com/currocam/HMMERutils/)'
      Policies:
      * retry_max_tries: 5

# base request fails when both seqdb and hmmdb

    You must specify either a seqdb or a hmmdb, not both.

