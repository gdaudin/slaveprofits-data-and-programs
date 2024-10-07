
profit_analysis . 1 1 0 1 0 1 0
profit_graphs . 1 1 0 1 0 1 0
descriptive_stat . 1 1 0 1 0 1 0
profit_regv2 . 1 1 0 1 0 1 0

profit_analysis 0 1 1 0 1 0 1 0
profit_graphs 0 1 1 0 1 0 1 0
profit_regv2 0 1 1 0 1 0 1 0

profit_analysis 1 1 1 0 1 0 1 0
profit_graphs 1 1 1 0 1 0 1 0
profit_regv2 1 1 1 0 1 0 1 0

* ROBUSTNESS TESTS
*assuming that no insurance was purchased if we have no positive proof that it was
profit_analysis 0.5 1 1 0 1 0 0 0
profit_graphs 0.5 1 1 0 1 0 0 0
profit_regv2 0.5 1 1 0 1 0 0 0
* assuming a 50% higher value of the ship relative to cost of other outlays that we assume in baseline
profit_analysis 0.5 1.5 1 0 1 0 1 0
profit_graphs 0.5 1.5 1 0 1 0 1 0
profit_regv2 0.5 1.5 1 0 1 0 1 0
* assuming that depreciation was only 10% rather than the 25% we assume in baseline.
profit_analysis 0.5 1 0.83 0 1.2 0 1 0
profit_graphs 0.5 1 0.83 0 1.2 0 1 0 
profit_regv2 0.5 1 0.83 0 1.2 0 1 0
* assuming that insurance was purchased on all ventures, even for the ones where the accounts we have seem to suggest total outlays.
profit_analysis 0.5 1 1 0 1 0 1 1
profit_graphs 0.5 1 1 0 1 0 1 1
profit_regv2 0.5 1 1 0 1 0 1 1
* assuming that value of the ship was not included in the accounts where the accounts we have seem to suggest total outlays/returns
profit_analysis 0.5 1 1 1 1 1 1 0
profit_graphs   0.5 1 1 1 1 1 1 0
profit_regv2 0.5 1 1 1 1 1 1 0
* assuming both of the above
profit_analysis 0.5 1 1 1 1 1 1 1
profit_graphs 0.5 1 1 1 1 1 1 1
profit_regv2 0.5 1 1 1 1 1 1 1





capture erase "Comparison between different assumptions.csv"
_renamefile "Comparison between different assumptions.txt" "Comparison between different assumptions.csv"
