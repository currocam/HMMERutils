# mock search_phmmer works

    Code
      .
    Warning <http_400>
      Bad Request (HTTP 400).
      Bad Request (HTTP 400).
    Output
      # A tibble: 232 x 47
         algor~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
         <chr>   <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
       1 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       2 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       3 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       4 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       5 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       6 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       7 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       8 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
       9 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
      10 phmmer  D701~       1     116 0.07     546676       0    3511     116  546676
      # ... with 222 more rows, 37 more variables: stats.user <dbl>,
      #   stats.domZ_setby <int>, stats.n_past_bias <int>, stats.sys <dbl>,
      #   stats.n_past_fwd <int>, stats.total <dbl>, stats.nmodels <int>,
      #   stats.nincluded <int>, stats.n_past_vit <int>, stats.nreported <int>,
      #   stats.domZ <dbl>, hits.archScore <chr>, hits.ph <chr>, hits.arch <chr>,
      #   hits.kg <chr>, hits.ndom <int>, hits.extlink <chr>, hits.taxid <chr>,
      #   hits.acc <chr>, hits.taxlink <chr>, hits.desc <chr>, hits.pvalue <dbl>, ...

# mock search_hmmscan works

    Code
      .
    Warning <http_400>
      Bad Request (HTTP 400).
      Bad Request (HTTP 400).
    Output
      # A tibble: 2 x 36
        algori~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
        <chr>    <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
      1 hmmscan  E518~       1       1 0.06      19632       0     282       1       1
      2 hmmscan  E518~       1       1 0.06      19632       0     282       1       1
      # ... with 26 more variables: stats.user <dbl>, stats.domZ_setby <int>,
      #   stats.n_past_bias <int>, stats.sys <dbl>, stats.n_past_fwd <int>,
      #   stats.total <dbl>, stats.nmodels <int>, stats.nincluded <int>,
      #   stats.n_past_vit <int>, stats.nreported <int>, stats.domZ <dbl>,
      #   hits.flags <int>, hits.nregions <int>, hits.ndom <int>, hits.name <chr>,
      #   hits.score <dbl>, hits.bias <chr>, hits.taxid <chr>, hits.acc <chr>,
      #   hits.domains <list>, hits.nincluded <int>, hits.evalue <dbl>, ...

# mock search_hmmsearch works

    Code
      .
    Warning <http_400>
      Bad Request (HTTP 400).
    Output
      # A tibble: 47 x 47
         algor~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
         <chr>   <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
       1 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       2 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       3 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       4 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       5 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       6 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       7 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       8 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
       9 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
      10 hmmsea~ 05CD~       1      47 0.03     546676       0    4155      47  546676
      # ... with 37 more rows, 37 more variables: stats.user <dbl>,
      #   stats.domZ_setby <int>, stats.n_past_bias <int>, stats.sys <dbl>,
      #   stats.n_past_fwd <int>, stats.total <dbl>, stats.nmodels <int>,
      #   stats.nincluded <int>, stats.n_past_vit <int>, stats.nreported <int>,
      #   stats.domZ <dbl>, hits.archScore <chr>, hits.ph <chr>, hits.arch <chr>,
      #   hits.kg <chr>, hits.ndom <int>, hits.extlink <chr>, hits.taxid <chr>,
      #   hits.acc <chr>, hits.taxlink <chr>, hits.desc <chr>, hits.pvalue <dbl>, ...

