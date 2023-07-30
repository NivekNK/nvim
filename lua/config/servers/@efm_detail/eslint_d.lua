return {
	lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
	lintIgnoreExitCode = true,
	lintStdin = true,
	lintFormats = {
		"%tarning %m | %f(%l,%c)",
		"%rror %m | %f(%l,%c)",
	},
}
