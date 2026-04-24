return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		keys = {
			-- { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Fzf: Find Files" },
			{ "<leader>f", "<cmd>FzfLua files<CR>", desc = "Fzf: Find Files" },
			-- { "<leader>fg", "<cmd>FzfLua git_files<CR>", desc = "Fzf: Git Files" },
			-- { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Fzf: Buffers" },
			{ "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "Fzf: Buffers" },
			-- { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Fzf: Recent Files" },
			-- { "<leader>fw", "<cmd>FzfLua live_grep<CR>", desc = "Fzf: Grep Words" },
			{ "<leader>mn", desc = "Memo: New" },
			{ "<leader>ml", desc = "Memo: List" },
			{ "<leader>mg", desc = "Memo: Grep" },
		},
		config = function()
			vim.env.FZF_DEFAULT_OPTS = "--layout=reverse"
			require("fzf-lua").setup({
				files = {
					prompt = "❯",
					cwd_prompt = false,
					fd_icons = true,
					git_icons = true,
				},
				buffers = {
					actions = {
						-- Ctrl-x でバッファーを削除
						["ctrl-x"] = { fn = require("fzf-lua").actions.buf_del, reload = true },
					},
				},
				winopts = {
					height = 0.85,
					width = 0.95,
					preview = {
						layout = "horizontal", -- ← 左右分割
						horizontal = "right:50%", -- ← 右側50%を preview に
					},
				},
			})

			-- Memo機能
			local memo_dir = vim.fn.expand("~/Documents/memo")

			local function ensure_memo_dir()
				if vim.fn.isdirectory(memo_dir) == 0 then
					vim.fn.mkdir(memo_dir, "p")
				end
			end

			-- 新規メモを作成（YYYYMMDDHHmmss.md形式）
			local function memo_new()
				ensure_memo_dir()
				local filename = os.date("%Y%m%d%H%M%S") .. ".md"
				local filepath = memo_dir .. "/" .. filename
				vim.cmd("edit " .. filepath)
			end

			-- メモ一覧をfzfで検索
			local function memo_list()
				ensure_memo_dir()
				require("fzf-lua").files({
					cwd = memo_dir,
					prompt = "Memo> ",
				})
			end

			-- メモ内をgrepで検索
			local function memo_grep()
				ensure_memo_dir()
				require("fzf-lua").live_grep({
					cwd = memo_dir,
					prompt = "Memo Grep> ",
				})
			end

			-- コマンド登録
			vim.api.nvim_create_user_command("MemoNew", memo_new, { desc = "Create new memo" })
			vim.api.nvim_create_user_command("MemoList", memo_list, { desc = "List memos with fzf" })
			vim.api.nvim_create_user_command("MemoGrep", memo_grep, { desc = "Grep memos" })

			-- キーマップ
			vim.keymap.set("n", "<leader>mn", memo_new, { desc = "Memo: New" })
			vim.keymap.set("n", "<leader>ml", memo_list, { desc = "Memo: List" })
			vim.keymap.set("n", "<leader>mg", memo_grep, { desc = "Memo: Grep" })
		end,
	},
}
