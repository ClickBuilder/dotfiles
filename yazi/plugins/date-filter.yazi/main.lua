return {
  entry = function()
    local cwd = os.getenv("PWD") or "."

    -- запускаем скрипт и ЖДЁМ результат напрямую
   os.execute(string.format(
  "bash ~/.config/yazi/scripts/date-filter.sh '%s'",
  cwd
))

    -- читаем результат
    local f = io.open("/tmp/yazi-date-filter", "r")
    if not f then return end

    local pattern = f:read("*l")
    f:close()
    os.remove("/tmp/yazi-date-filter")

    if not pattern or pattern == "" then return end

    ya.manager_emit("sort", { "date", reverse = true })
    ya.manager_emit("filter", { pattern })
  end,
}
