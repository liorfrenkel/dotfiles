-- Custom commands for Neovim
-- Add any additional commands here

-- BedrockSetup Command
-- This command runs the necessary steps to set up AWS Bedrock credentials for Avante

vim.api.nvim_create_user_command("BedrockSetup", function()
	local aws_output = vim.fn.system("aws --profile melio-eilat configure export-credentials")
	if vim.v.shell_error ~= 0 then
		vim.notify("Error exporting AWS credentials: " .. aws_output, vim.log.levels.ERROR)
		return
	end

	local ok, credentials = pcall(vim.fn.json_decode, aws_output)
	if not ok or not credentials then
		vim.notify("Failed to parse AWS credentials", vim.log.levels.ERROR)
		return
	end

	local accessKeyId = credentials.AccessKeyId
	local secretAccessKey = credentials.SecretAccessKey
	local sessionToken = credentials.SessionToken

	if not accessKeyId or not secretAccessKey then
		vim.notify("AWS credentials are incomplete", vim.log.levels.ERROR)
		return
	end

	local region = "us-east-1"
	local bedrock_keys = accessKeyId .. "," .. secretAccessKey .. "," .. region

	if sessionToken then
		bedrock_keys = bedrock_keys .. "," .. sessionToken
	end

	vim.env.BEDROCK_KEYS = bedrock_keys

	vim.notify("Bedrock credentials have been set successfully!", vim.log.levels.INFO)
end, {})

