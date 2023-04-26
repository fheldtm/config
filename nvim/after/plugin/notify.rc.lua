local status, notify_local = pcall(require, 'notify')
if (not status) then return end

_G.notify = notify_local
_G.notify.setup {
  background_colour = '#000000'
}
