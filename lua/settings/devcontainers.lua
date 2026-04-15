local dcexists, dc = pcall(require, "devcontainer")

if dcexists then
  dc.setup{}
end
