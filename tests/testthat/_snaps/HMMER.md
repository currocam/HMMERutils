# mock phmmer works

    Code
      .
    Output
      # A tibble: 116 x 47
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
      # ... with 106 more rows, 37 more variables: stats.user <dbl>,
      #   stats.domZ_setby <int>, stats.n_past_bias <int>, stats.sys <dbl>,
      #   stats.n_past_fwd <int>, stats.total <dbl>, stats.nmodels <int>,
      #   stats.nincluded <int>, stats.n_past_vit <int>, stats.nreported <int>,
      #   stats.domZ <dbl>, hits.archScore <chr>, hits.ph <chr>, hits.arch <chr>,
      #   hits.kg <chr>, hits.ndom <int>, hits.extlink <chr>, hits.taxid <chr>,
      #   hits.acc <chr>, hits.taxlink <chr>, hits.desc <chr>, hits.pvalue <dbl>, ...

# mock hmmscan works

    Code
      .
    Output
      # A tibble: 1 x 36
        algori~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
        <chr>    <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
      1 hmmscan  2D5A~       1       1 0.06      19632       0     282       1       1
      # ... with 26 more variables: stats.user <dbl>, stats.domZ_setby <int>,
      #   stats.n_past_bias <int>, stats.sys <dbl>, stats.n_past_fwd <int>,
      #   stats.total <dbl>, stats.nmodels <int>, stats.nincluded <int>,
      #   stats.n_past_vit <int>, stats.nreported <int>, stats.domZ <dbl>,
      #   hits.flags <int>, hits.nregions <int>, hits.ndom <int>, hits.name <chr>,
      #   hits.score <dbl>, hits.bias <chr>, hits.taxid <chr>, hits.acc <chr>,
      #   hits.domains <list>, hits.nincluded <int>, hits.evalue <dbl>, ...

# mock hmmsearch works

    Code
      .
    Output
      # A tibble: 110 x 47
         algor~1 uuid  stats~2 stats~3 stats~4 stats.Z stats~5 stats~6 stats~7 stats~8
         <chr>   <chr>   <dbl>   <int> <chr>     <dbl>   <int>   <int>   <int>   <int>
       1 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       2 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       3 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       4 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       5 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       6 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       7 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       8 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
       9 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
      10 hmmsea~ CB34~       1     110 0.06     565928       0   19129     110  565928
      # ... with 100 more rows, 37 more variables: stats.user <dbl>,
      #   stats.domZ_setby <int>, stats.n_past_bias <int>, stats.sys <dbl>,
      #   stats.n_past_fwd <int>, stats.total <dbl>, stats.nmodels <int>,
      #   stats.nincluded <int>, stats.n_past_vit <int>, stats.nreported <int>,
      #   stats.domZ <dbl>, hits.archScore <chr>, hits.ph <chr>, hits.arch <chr>,
      #   hits.kg <chr>, hits.ndom <int>, hits.extlink <chr>, hits.acc2 <chr>,
      #   hits.taxid <chr>, hits.acc <chr>, hits.taxlink <chr>, hits.desc <chr>, ...

