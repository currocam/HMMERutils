# Adding sequences to phmmer works in local

    Code
      .
    Message <packageStartupMessage>
      Registered S3 method overwritten by 'hoardr':
        method           from
        print.cache_info httr
    Output
      # A tibble: 116 x 41
         taxa.taxid taxa.no ~1 taxa.~2 taxa.~3 taxa.~4 taxa.~5 taxa.~6 taxa.~7 taxa.~8
         <chr>      <chr>      <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
       1 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       2 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       3 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       4 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       5 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       6 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       7 10090      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       8 10116      cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
       9 2899231    cellular ~ Eukary~ Opisth~ Metazoa Eumeta~ Bilate~ Deuter~ Chorda~
      10 32630      other ent~ <NA>    <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
      # ... with 106 more rows, 32 more variables: taxa.subphylum <chr>,
      #   taxa.clade.4 <chr>, taxa.clade.5 <chr>, taxa.clade.6 <chr>,
      #   taxa.clade.7 <chr>, taxa.superclass <chr>, taxa.clade.8 <chr>,
      #   taxa.clade.9 <chr>, taxa.clade.10 <chr>, taxa.class <chr>,
      #   taxa.clade.11 <chr>, taxa.clade.12 <chr>, taxa.clade.13 <chr>,
      #   taxa.superorder <chr>, taxa.clade.14 <chr>, taxa.order <chr>,
      #   taxa.suborder <chr>, taxa.clade.15 <chr>, taxa.family <chr>, ...

---

    Code
      .
    Message <simpleMessage>
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
      No ENTREZ API key provided
       Get one via taxize::use_entrez()
      See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
    Output
      # A tibble: 116 × 41
         taxa.taxid taxa.no …¹ taxa.…² taxa.…³ taxa.…⁴ taxa.…⁵ taxa.…⁶ taxa.…⁷ taxa.…⁸
         <chr>      <chr>      <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
       1 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       2 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       3 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       4 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       5 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       6 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       7 10090      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       8 10116      cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
       9 2899231    cellular … Eukary… Opisth… Metazoa Eumeta… Bilate… Deuter… Chorda…
      10 32630      other ent… <NA>    <NA>    <NA>    <NA>    <NA>    <NA>    <NA>   
      # … with 106 more rows, 32 more variables: taxa.subphylum <chr>,
      #   taxa.clade.4 <chr>, taxa.clade.5 <chr>, taxa.clade.6 <chr>,
      #   taxa.clade.7 <chr>, taxa.superclass <chr>, taxa.clade.8 <chr>,
      #   taxa.clade.9 <chr>, taxa.clade.10 <chr>, taxa.class <chr>,
      #   taxa.clade.11 <chr>, taxa.clade.12 <chr>, taxa.clade.13 <chr>,
      #   taxa.superorder <chr>, taxa.clade.14 <chr>, taxa.order <chr>,
      #   taxa.suborder <chr>, taxa.clade.15 <chr>, taxa.family <chr>, …

