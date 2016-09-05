
class 'MasterDialog' (DisplayActivity)

function MasterDialog:__init()
   DisplayActivity.__init(self, 'master')
end

function MasterDialog:register(pusher)
   LOG("MasterDialog: register()")
   DisplayActivity.register(self, pusher)
end

function MasterDialog:update()
   LOG("MasterDialog: update()")
end
