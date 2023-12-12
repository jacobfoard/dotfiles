local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local b_components = require("windline.components.basic")
local state = _G.WindLine.state
local vim_components = require("windline.components.vim")
local HSL = require("wlanimation.utils")
local animation = require("wlanimation")
local efffects = require("wlanimation.effects")

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")

local hl_list = {
    Black = { "white", "black" },
    White = { "black", "white" },
    Normal = { "NormalFg", "NormalBg" },
    Inactive = { "InactiveFg", "InactiveBg" },
    Active = { "ActiveFg", "ActiveBg" },
}
local basic = {}

local airline_colors = {}

airline_colors.a = {
    NormalSep = { "blue", "black" },
    InsertSep = { "green", "black" },
    VisualSep = { "yellow", "black" },
    ReplaceSep = { "magenta", "black" },
    CommandSep = { "red", "black" },
    Normal = { "black", "blue" },
    Insert = { "black", "green" },
    Visual = { "black", "yellow" },
    Replace = { "black", "magenta" },
    Command = { "black", "red" },
}

airline_colors.b = {
    NormalSep = { "black", "blue" },
    InsertSep = { "black", "green" },
    VisualSep = { "black", "yellow" },
    ReplaceSep = { "black", "magenta" },
    CommandSep = { "black", "red" },
    Sep = { "black", "black" },
    Normal = { "blue", "black" },
    Insert = { "green", "black" },
    Visual = { "yellow", "black" },
    Replace = { "magenta", "black" },
    Command = { "red", "black" },
}

airline_colors.c = {
    NormalSep = { "blue", "black" },
    InsertSep = { "green", "black" },
    VisualSep = { "yellow", "black" },
    ReplaceSep = { "magenta", "black" },
    CommandSep = { "red", "black" },
    Normal = { "black", "blue" },
    Insert = { "black", "green" },
    Visual = { "black", "yellow" },
    Replace = { "black", "magenta" },
    Command = { "black", "red" },
}

basic.divider = { b_components.divider, hl_list.Black }

local hide_in_width = function()
    return vim.fn.winwidth(0) > 100
end

basic.section_a = {
    hl_colors = airline_colors.a,
    text = function()
        return {
            { " " .. state.mode[1] .. " ", state.mode[2] },
            { sep.right_filled, state.mode[2] .. "Sep" },
        }
    end,
}

basic.section_b = {
    hl_colors = airline_colors.b,
    text = function()
        return {
            { " ", state.mode[2] },
            { b_components.file_icon(""), "" },
            { " ", "" },
            { b_components.file_name(""), "" },
            { b_components.file_modified(" "), "" },
            { sep.right_filled, state.mode[2] .. "Sep" },
        }
    end,
}

local get_git_branch = git_comps.git_branch()

basic.section_c = {
    hl_colors = airline_colors.c,
    text = function()
        local branch_name = get_git_branch()
        if #branch_name > 2 then
            return {
                { " ", state.mode[2] },
                { git_comps.git_branch({ icon = "" }), state.mode[2] },
                { " ", "" },
                { sep.right_filled, state.mode[2] .. "Sep" },
            }
        end
        return { { sep.right_filled, state.mode[2] .. "Sep" } }
    end,
}

basic.section_x = {
    hl_colors = airline_colors.b,
    text = function()
        return {
            { sep.left, "Sep" },
            { b_components.file_type({ icon = false }), state.mode[2] },
            { " ", "" },
            { b_components.file_size(), "" },
            { " ", "" },
        }
    end,
}

basic.section_z = {
    hl_colors = airline_colors.a,
    text = function()
        return {
            { sep.left_filled, state.mode[2] .. "Sep" },
            { " ", state.mode[2] },
            { b_components.progress, "" },
            { " ", "" },
            { b_components.line_col, "" },
        }
    end,
}

basic.lsp_diagnos = {
    name = "diagnostic",
    hl_colors = { red = { "red", "black" }, yellow = { "yellow", "black" }, blue = { "blue", "black" } },
    text = function()
        if hide_in_width() and lsp_comps.check_lsp() then
            return {
                { " ", "red" },
                { lsp_comps.lsp_error({ format = "  %s", show_zero = true }), "red" },
                { lsp_comps.lsp_warning({ format = "  %s", show_zero = true }), "yellow" },
                { lsp_comps.lsp_hint({ format = " 󰋼 %s", show_zero = true }), "blue" },
            }
        end
        return { " ", "red" }
    end,
}

basic.git = {
    name = "git",
    hl_colors = { green = { "green", "black" }, red = { "red", "black" }, blue = { "blue", "black" } },
    text = function()
        if hide_in_width() and git_comps.is_git() then
            return {
                { git_comps.diff_added({ format = "  %s" }), "green" },
                { git_comps.diff_removed({ format = "  %s" }), "red" },
                { git_comps.diff_changed({ format = "  %s" }), "blue" },
            }
        end
        return ""
    end,
}

local quickfix = {
    filetypes = { "qf", "Trouble" },
    active = {
        { "🚦 Diagnostics ", { "white", "black" } },
        { helper.separators.right_filled, { "black", "black_light" } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { "cyan", "black_light" },
        },
        { " Total : %L ", { "cyan", "black_light" } },
        { helper.separators.right_filled, { "black_light", "InactiveBg" } },
        { " ", { "InactiveFg", "InactiveBg" } },
        basic.divider,
        { helper.separators.right_filled, { "InactiveBg", "black" } },
        { "🧛 ", { "white", "black" } },
    },
    show_inactive = true,
}

local explorer = {
    filetypes = { "fern", "NvimTree", "lir" },
    active = {
        { "  ", { "white", "black" } },
        { helper.separators.right_filled, { "black", "black_light" } },
        { b_components.divider, "" },
        { b_components.file_name(""), { "white", "black_light" } },
    },
    show_inactive = true,
}

local default = {
    filetypes = { "default" },
    active = {
        basic.section_a,
        basic.section_b,
        basic.section_c,
        basic.git,
        basic.lsp_diagnos,
        basic.divider,
        { vim_components.search_count(), { "cyan", "black" } },
        { lsp_comps.lsp_name(), { "white", "black" } },
        basic.section_x,
        basic.section_z,
    },
    inactive = {
        { b_components.full_file_name, hl_list.Inactive },
        { b_components.divider, hl_list.Inactive },
        { b_components.line_col, hl_list.Inactive },
        { b_components.progress, hl_list.Inactive },
    },
}

windline.setup({
    colors_name = function(colors)
        colors.blue = "#00afff"

        return colors
    end,
    statuslines = { default },
})
