local M = {}

M.dtr = function(d) return d * math.pi / 180 end
M.rtd = function(r) return r * 180 / math.pi end

M.sin = function(d) return math.sin(M.dtr(d)) end
M.cos = function(d) return math.cos(M.dtr(d)) end
M.tan = function(d) return math.tan(M.dtr(d)) end

M.arcsin = function(d) return M.rtd(math.asin(d)) end
M.arccos = function(d) return M.rtd(math.acos(d)) end
M.arctan2 = function(y, x) return M.rtd(math.atan2(y, x)) end
M.arccot = function(x) return M.rtd(math.atan(1 / x)) end

M.mod = function(a, b)
    return ((a % b) + b) % b
end

return M
