local genres = {
  "Alternative", "Anime", "Blues", "Children's", "Classical",
  "Comedy", "Country", "Crossover", "Easy Listening", "Folk",
  "Fusion", "Game", "Gospel", "Hard Rock", "Heavy Metal", "Hip Hop", "House", "Instrumental",
  "Jazz", "Jpop", "Kpop", "Other", "Pop", "Progressive Rock",
  "Punk", "R&B", "Radio", "Rock", "Soul",
  "Sound Drama", "Soundtrack", "Spoken & Audio", "Voice Training",
}

local function in_genres_context()
  local lnum = vim.fn.line(".")
  local cur_line = vim.fn.getline(lnum)
  if not cur_line:match("^%s*%-") then return false end
  local cur_indent = vim.fn.indent(lnum)
  for i = lnum - 1, math.max(1, lnum - 200), -1 do
    local line = vim.fn.getline(i)
    if line:match("^%s*$") then goto continue end
    local indent = vim.fn.indent(i)
    if not line:match("^%s*%-") and indent <= cur_indent then
      return line:match("genres%s*:") ~= nil
    end
    ::continue::
  end
  return false
end

_G._yaml_genre_complete = function(findstart, base)
  if findstart == 1 then
    if not in_genres_context() then return -3 end
    local line = vim.fn.getline(".")
    local col = vim.fn.col(".") - 1
    local i = col
    while i > 0 and line:sub(i, i) ~= " " do
      i = i - 1
    end
    return i
  else
    local results = {}
    local b = base:lower()
    for _, g in ipairs(genres) do
      if b == "" or g:lower():find(b, 1, true) then
        table.insert(results, { word = g, menu = "[genre]" })
      end
    end
    return results
  end
end

vim.bo.omnifunc = "v:lua._yaml_genre_complete"

-- '- ' と入力したとき genres 配下なら自動で補完ポップアップを出す
vim.api.nvim_create_autocmd("TextChangedI", {
  buffer = 0,
  callback = function()
    if vim.fn.pumvisible() == 1 then return end
    local line = vim.fn.getline(".")
    if line:match("^%s*%-%s$") and in_genres_context() then
      vim.schedule(function()
        vim.api.nvim_feedkeys(vim.keycode("<C-x><C-o>"), "n", false)
      end)
    end
  end,
})
