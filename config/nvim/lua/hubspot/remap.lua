vim.keymap.set("n", "<leader>tt", require("hubspot.test_toggle").toggle, { desc = "Toggle test/source file" })
vim.keymap.set("n", "<leader>wp", require("hubspot.bend_picker").pick, { desc = "Pick bend workspace" })
