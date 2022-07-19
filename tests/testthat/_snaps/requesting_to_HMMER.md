# phmmer works

    # A tibble: 1 x 18
      seq.name dbs      uuid  score.url stats hits  domains text.url tab.url xml.url
      <chr>    <chr>    <chr> <chr>     <nam> <nam> <named> <chr>    <chr>   <chr>  
    1 1        swisspr~ 4EC4~ http://w~ <df>  <df>  <df>    https:/~ https:~ https:~
    # ... with 8 more variables: json.url <chr>, fasta.url <chr>,
    #   fullfasta.url <chr>, alignedfasta.url <chr>, stockholm.url <chr>,
    #   clustalw.url <chr>, psiblast.url <chr>, phylip.url <chr>

# hmmsearch works

    # A tibble: 1 x 18
      seq.name dbs   uuid     score.url stats hits  domains text.url tab.url xml.url
      <chr>    <chr> <chr>    <chr>     <nam> <nam> <named> <chr>    <chr>   <chr>  
    1 1        pdb   F5B1AA4~ http://w~ <df>  <df>  <df>    https:/~ https:~ https:~
    # ... with 8 more variables: json.url <chr>, fasta.url <chr>,
    #   fullfasta.url <chr>, alignedfasta.url <chr>, stockholm.url <chr>,
    #   clustalw.url <chr>, psiblast.url <chr>, phylip.url <chr>

# hmmscan works

    # A tibble: 1 x 11
      seq.name dbs   uuid    score.url stats hits  domains  text.url tab.url xml.url
      <chr>    <chr> <chr>   <chr>     <nam> <nam> <named > <chr>    <chr>   <chr>  
    1 1        pfam  C228F8~ http://w~ <df>  <df>  <tibble> https:/~ https:~ https:~
    # ... with 1 more variable: json.url <chr>

# hmmscan throws warning Bad Request when sequence database

    Bad Request (HTTP 400).

