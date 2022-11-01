# Test that extract hmmer works with phmmer and pdb for extract pdbs

    Code
      .
    Output
      # A tibble: 266 x 49
         algor~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
         <chr>   <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
       1 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       2 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       3 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       4 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       5 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       6 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       7 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       8 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
       9 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
      10 phmmer  017C~       1     116 0.07     546676       0    3511     116  546676
      # ... with 256 more rows, 39 more variables: stats.user <dbl>,
      #   stats.domZ_setby <int>, stats.n_past_bias <int>, stats.sys <dbl>,
      #   stats.n_past_fwd <int>, stats.total <dbl>, stats.nmodels <int>,
      #   stats.nincluded <int>, stats.n_past_vit <int>, stats.nreported <int>,
      #   stats.domZ <dbl>, hits.archScore <chr>, hits.ph <chr>, hits.arch <chr>,
      #   hits.kg <chr>, hits.ndom <int>, hits.extlink <chr>, hits.taxid <chr>,
      #   hits.acc <chr>, hits.taxlink <chr>, hits.desc <chr>, hits.pvalue <dbl>, ...

