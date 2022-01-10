package main

deny_totalDiff[msg] {
	maxDiff = 150.0
	to_number(input.diffTotalMonthlyCost) >= maxDiff

	msg := sprintf(
		"Total monthly cost diff must be less than $%.2f (actual diff is $%.2f)",
		[maxDiff, to_number(input.diffTotalMonthlyCost)],
	)
}
