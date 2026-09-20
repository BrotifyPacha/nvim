local dap = require('dap')
dap.set_log_level('TRACE')

require('user.plugins-config.dap.adapters')
require('user.plugins-config.dap.ui')
require('user.plugins-config.dap.keymaps')
