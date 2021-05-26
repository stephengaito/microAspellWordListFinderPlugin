VERSION = "1.0.0"

local micro    = import("micro")

local os       = import("os")
local filepath = import("path/filepath")
local regexp   = import("regexp")
local runtime  = import("runtime")

function updateAspellArgs(buf, aPWL) 
  local re, err = regexp.Compile("--personal=[^[:space:]]*")
  if err ~= nil then
    micro.InfoBar():Error("Could not compile the updateAspellArgs regexp")
  else
    local origArgs = buf.Settings["aspell.args"]
    local newArgs  = re:ReplaceAllString(origArgs, "--personal="..aPWL)
    if origArgs == newArgs then
      newArgs = newArgs.." --personal="..aPWL
    end
    micro.Log("Using aspell personal word list: ["..aPWL.."]")
    buf.Settings["aspell.args"] = newArgs
  end
end

-- See: https://stackoverflow.com/a/51217736
--
function userHomeDir()
  local home = ""
  if runtime.GOOS == "windows" then
    home = os.Getenv("HOMEDRIVE") .. os.Getenv("HOMEPATH")
    if home == "" then
      home = os.Getenv("USERPROFILE")
    end
    return home
  elseif runtime.GOOS == "linux" then
    home = os.Getenv("XDG_CONFIG_HOME")
    if home ~= "" then
      return home
    end
  end
  home = os.Getenv("HOME")
  return home
end

function findAspellWordList(buf) 
  local curDir, err = os.Getwd()
  if err ~= nil then
    micro.InfoBar():Error("Could not find the current directory")
    return
  end

  while curDir ~= "/" do
    local possiblePWL = filepath.Join(curDir, ".aspell.pws")
    local _, err = os.Stat(possiblePWL)
    if err == nil then
      updateAspellArgs(buf, possiblePWL)
      return
    end
    curDir = filepath.Dir(curDir)
  end

  local theUserHomeDir = userHomeDir()
  if err == nil and theUserHomeDir ~= "" then
    local possiblePWL = filepath.Join(theUserHomeDir, ".config", "aspell", ".aspell.pws")
    local _, err = os.Stat(possiblePWL)
    if err == nil then
      updateAspellArgs(buf, possiblePWL)
      return
    end
    local possiblePWL = filepath.Join(theUserHomeDir, ".config", ".aspell.pws")
    local _, err = os.Stat(possiblePWL)
    if err == nil then
      updateAspellArgs(buf, possiblePWL)
      return
    end
  end
end

function onBufferOpen(buf) 
  findAspellWordList(buf)
end