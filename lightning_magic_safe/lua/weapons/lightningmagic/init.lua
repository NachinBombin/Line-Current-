AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

CreateConVar("sv_kysnow_effects",1,FCVAR_NONE,"Enable/Disable visual effects",0,1)
local enableeffects = GetConVar( "sv_kysnow_effects" )

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self.Owner:EmitSound( 'Weapon_Dystopia_Sparky.Draw' )
	
	timer.Simple( self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_DRAW ) ) + 0.01, function() 
		self:SendWeaponAnim( ACT_VM_IDLE )
	end)
	
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_DRAW ) + 0.5))
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_DRAW ) + 0.5))
	
	self:SetNWBool( 'self.Cast', false )
	self.IdleAnim = true
end
function SWEP:OnRestore()

local ShockTable = {}
local GMSVEffectStatus = {}

self.LightningStrike = 0

local traceeffect = EffectData()
traceeffect:SetEntity(self)

end


function SWEP:EffectStatusShock(id)
local ent = ents.GetByIndex( id )
if !IsValid(ent) then return end
local hastable
for i=1,#ShockTable do
if ShockTable[i] == ent then
hastable = true
end
end
if !hastable then
table.insert(ShockTable,ent)
end
end 


function SWEP:Holster()

	self:StopSound( "Weapon_Dystopia_Sparky.Charge" )
	self:StopSound( "Weapon_Dystopia_Sparky.FireInitial" )
	self:StopSound( "Weapon_Dystopia_Sparky.AltCharge" )
	if IsValid(self.Tesla) then
		self.Tesla:Remove()
		self.IdleAnim = true
	end
	self:SetNWBool( 'self.Cast', false )
	return true
end

function SWEP:Think()
	
	if (!self.Owner || self.Owner == NULL) then return end
	
	
	
	if ( self.Owner:KeyDown( IN_ATTACK )) then
			if self:Clip1() > 1 and self:CanPrimaryAttack() then
				self:PlayAnim()
			end
	elseif ( self.Owner:KeyReleased( IN_ATTACK )) or self:Clip1() < 1 then
		if !self.IdleAnim then
			self:PlayIdleAnim()
		end
	end
	
	
	
	if IsValid(self.Tesla) then
		local Forward = self.Owner:EyeAngles():Forward()
		self.Tesla:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 64 )
		self.Tesla:SetAngles( self.Owner:EyeAngles() )
	end

	if ( self:Clip1() < 1 or self.Owner:WaterLevel() > 1 ) and !self.IdleAnim then
		if !self.IdleAnim then
			self:PlayIdleAnim()
		end
	end
end

hook.Add("PlayerButtonDown","ltgthink",function(ply,key)
if ply:Health() > 0 and ply:GetActiveWeapon():IsValid() then
    if key == KEY_LALT and ply:GetActiveWeapon():GetClass() == "lightningmagic" then
    local allents = ents.GetAll()
    for k,v in pairs(allents) do
    if v:GetClass() == "flyltg" then
    if v.Owner == ply then
    v:SetNWBool("return",true)
    v:SetNWBool("manual",false)
    ply:SetNWBool("showltgswp",false)
    end
    end
    end
end
end
end)

function SWEP:PlayIdleAnim()
	if !self.IdleAnim then
		self.IdleAnim = true
		self:SendWeaponAnim( ACT_VM_IDLE )
		self:StopSound( "Weapon_Dystopia_Sparky.Charge" )
	end
end

function SWEP:PlayAnim()
	if self.IdleAnim and self:CanPrimaryAttack() then
		self.IdleAnim = false
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	end
end

function SWEP:PrimaryAttack()

	if self.LightningStrike < CurTime() then
local trace = {
start = self.Owner:EyePos(),
endpos = self.Owner:EyePos() + self.Owner:GetAimVector()*9000 + VectorRand()*200,
filter = self.Owner
}
local tr = util.TraceLine( trace )
if tr.Hit then
if SERVER then
sound.Play( "magic/lightninghit" .. math.random(1,3) .. ".wav", self.Owner:EyePos(), 75, 100  )
sound.Play( "npc/roller/mine/rmine_explode_shock1.wav", tr.HitPos, 75, 100  )
end
local vec = self.Owner:EyePos() + Vector(0,0,-10) 
if game.SinglePlayer() then
local effectdata = EffectData()
effectdata:SetOrigin( tr.HitPos )
effectdata:SetStart( vec )
effectdata:SetEntity(self.Owner)
util.Effect( "mg_lightbolt", effectdata )
else
if SERVER then
net.Start( "FixEffectsMG" )
net.WriteVector( tr.HitPos )
net.WriteVector( vec )
net.WriteEntity( self.Owner )
net.Broadcast()
end
end
if !(tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
if game.SinglePlayer() then
local effectdata = EffectData()
effectdata:SetOrigin( tr.HitPos )
effectdata:SetScale(3)
effectdata:SetRadius(0.3)
effectdata:SetMagnitude(0.3)
util.Effect( "cball_bounce", effectdata )
else
if SERVER then
net.Start( "FixEffectsMG2" )
net.WriteVector( tr.HitPos )
net.Broadcast()
end
end
end
if SERVER then
local effectent = ents.Create("point_tesla")
effectent:SetPos(tr.HitPos)
effectent:SetKeyValue("texture","models/effects/vol_light001.vmt")
effectent:SetKeyValue("interval_max",0.2)
effectent:SetKeyValue("interval_min",0.1)
effectent:SetKeyValue("lifetime_max",0.1)
effectent:SetKeyValue("lifetime_min",0.1)
effectent:SetKeyValue("beamcount_max",1)
effectent:SetKeyValue("beamcount_min",1)
effectent:SetKeyValue("thick_max",5)
effectent:SetKeyValue("m_flRadius",1)
effectent:SetKeyValue("m_Color","255 255 255")
effectent:Spawn()
effectent:Fire("DoSpark","",0)
effectent:Fire("kill","",1)
local effectent = ents.Create("point_tesla")
effectent:SetPos(vec)
effectent:SetKeyValue("texture","models/effects/vol_light001.vmt")
effectent:SetKeyValue("interval_max",0.2)
effectent:SetKeyValue("interval_min",0.1)
effectent:SetKeyValue("lifetime_max",0.1)
effectent:SetKeyValue("lifetime_min",0.1)
effectent:SetKeyValue("beamcount_max",1)
effectent:SetKeyValue("beamcount_min",1)
effectent:SetKeyValue("thick_max",5)
effectent:SetKeyValue("m_flRadius",1)
effectent:SetKeyValue("m_Color","255 255 255")
effectent:Spawn()
effectent:Fire("DoSpark","",0)
effectent:Fire("kill","",1)
end
if IsValid(tr.Entity) then
local target = tr.Entity
if SERVER then
local dmginfo = DamageInfo()
dmginfo:SetDamage( 500 )
if (target:GetClass() == "npc_strider" or target:GetClass() == "npc_combinegunship") then
dmginfo:SetDamageType( DMG_GENERIC )
elseif target:GetClass() == "npc_helicopter" then
dmginfo:SetDamageType( DMG_AIRBOAT )
else
dmginfo:SetDamageType( bit.bor(DMG_GENERIC,DMG_SHOCK) )
end
dmginfo:SetAttacker( self.Owner )
dmginfo:SetInflictor( self )
dmginfo:SetDamageForce( self.Owner:GetAimVector()*4000 )
dmginfo:SetDamagePosition(tr.HitPos)
target:TakeDamageInfo( dmginfo )
target:SetNWInt("NPCHitByLightningMG",20)
if SERVER then
self:CallOnClient("EffectStatusShock",tostring(target:EntIndex()))
end
end
local effectdata = EffectData()
effectdata:SetOrigin( target:GetPos() )
effectdata:SetStart( target:GetPos() )
effectdata:SetMagnitude(15)
effectdata:SetEntity( target )
util.Effect( "TeslaHitBoxes", effectdata)
if SERVER then
if IsValid(target:GetPhysicsObject()) then
target:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*500 + VectorRand()*200)
end
timer.Create("lightning_resetmg" .. target:EntIndex(),0.05,20,function()
if IsValid(target) then
target:SetNWInt("NPCHitByLightningMG",target:GetNWInt("NPCHitByLightningMG") - 1)
end
end)
end
end
end
self.LightningStrike = CurTime() + 0.1
end
end


hook.Add("Think","lightningthink",function()
    net.Receive("SltKYSAb",function(len,ply)
        local Ab = net.ReadString()
        ply:SetNWString("LTGABility",Ab)
    end)
    local allply = player.GetAll()
    for k,v in pairs(allply) do
        if v:Health() > 0 then
        end
            if v:OnGround() then
                v:SetVar("LTGFly",false)
            end
            if v:GetActiveWeapon():IsValid() then
        if v:GetActiveWeapon():GetClass() == "lightningmagic" then
        end
        
                            if  v:GetActiveWeapon():GetClass() == "lightningmagic" then
                                
                                if v:GetActiveWeapon():GetVar("effectdelay") == nil then
                                    v:GetActiveWeapon():SetVar("effectdelay",0)
                                end
                                if v:GetActiveWeapon():GetVar("effectdelay") < CurTime() and enableeffects:GetInt()==1 then

local function zapEffect(target)
    local effectdata = EffectData()
    effectdata:SetStart(target:GetShootPos())
    effectdata:SetOrigin(target:GetShootPos())
    effectdata:SetScale(1)
    effectdata:SetMagnitude(1)
    effectdata:SetScale(3)
    effectdata:SetRadius(1)
    effectdata:SetEntity(target)
    for i = 1, 50, 1 do
        timer.Simple(1 / i, function()
            util.Effect("TeslaHitBoxes", effectdata, true, true)
        end)
    end

end
    zapEffect(v)
v:GetActiveWeapon():SetVar("effectdelay",CurTime()+1)
                            end
                        end
                    end
                end
                end)



	


function SWEP:SecondaryAttack()
	
	if self:CanSecondaryAttack() then	
		local tg = self.Owner:GetEyeTrace()
		self:PlayIdleAnim()
		local Forward = self.Owner:EyeAngles():Forward()
		local Up = self.Owner:EyeAngles():Up()
		local Right = self.Owner:EyeAngles():Right()
		
		local entity = ents.Create( "teslacoil_teslaorb" )
		entity:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 64 )
		entity:SetAngles( self.Owner:EyeAngles() )
		entity:SetOwner( self.Owner )
		entity:Spawn()
		timer.Simple(1.6, function()
				if IsValid(self.Tesla) then
					self.Tesla:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector():Angle():Forward() * 300 )
					self.Tesla = nil
					self:SetNWEntity( 'self.TeslaOrb', NULL )
				end
			timer.Simple(1.1, function() 
				if self:IsValid() and self.Owner:GetActiveWeapon():GetClass() == self:GetClass() then 
					
					self:SetNWBool( 'self.Cast', false )
				end 
			end)
		end)
		self.Tesla = entity
		self:SetNWEntity( 'self.TeslaOrb', self.Tesla )
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:EmitSound( "Weapon_Dystopia_Sparky.AltCharge" )
		self:SetNWBool( 'self.Cast', true )

		self:TakePrimaryAmmo( 25 )
		self:SetNextSecondaryFire(CurTime() + 1)
	else
		self.Owner:EmitSound( "Weapon_Dystopia_Sparky.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
	end
	
end


function SWEP:Reload()

                                
                                
 local pos = self.Owner:GetEyeTrace().HitPos
                            local pretr = {start = pos,endpos = pos + Vector(0,0,999999999999),filter = ents.GetAll()}
                            local trc = util.TraceLine(pretr)
                            local grnd = pos
                            local sky = trc.HitPos
                            local vec = grnd - sky
                            for i = 1,5 do
                                if SERVER then
                            local LA = ents.Create("env_laser")
                            LA:SetKeyValue("targetname", "laser")
                            LA:SetKeyValue("lasertarget", "laser")
                            LA:SetKeyValue("renderamt", "255")
                            LA:SetKeyValue("renderfx", "15")
                            LA:SetKeyValue("rendercolor", "255 255 255")
                            LA:SetKeyValue("texture", "sprites/xbeam2.spr")
                            LA:SetKeyValue("texturescroll", "35")
                            LA:SetKeyValue("dissolvetype", "2")
                            LA:SetKeyValue("spawnflags", "32")
                            LA:SetKeyValue("width", "10")
                            LA:SetKeyValue("damage", "20000")
                            LA:SetKeyValue("noiseamplitude", "1")
                             timer.Simple(1.45,function()
                            LA:Spawn()
                            LA:Fire("Kill","",0.35)
                            LA:Fire("turnoff","",0)
                            LA:Fire("turnon","",1)
                            LA:SetPos(sky)
                        end)
                            local LA = ents.Create("env_laser")
                            LA:SetKeyValue("targetname", "laser")
                            LA:SetKeyValue("lasertarget", "laser")
                            LA:SetKeyValue("renderamt", "255")
                            LA:SetKeyValue("renderfx", "15")
                            LA:SetKeyValue("rendercolor", "255 255 255")
                            LA:SetKeyValue("texture", "sprites/xbeam2.spr")
                            LA:SetKeyValue("texturescroll", "35")
                            LA:SetKeyValue("dissolvetype", "2")
                            LA:SetKeyValue("spawnflags", "32")
                            LA:SetKeyValue("width", "10")
                            LA:SetKeyValue("damage", "20000")
                            LA:SetKeyValue("noiseamplitude", "1")
                              timer.Simple(1.45,function()
                            LA:Spawn()
                            LA:Fire("Kill","",0.35)
                            LA:Fire("turnoff","",0)
                            LA:Fire("turnon","",0)
                            LA:SetPos(grnd)
                        end)
                                end
                            
                            end
                            if SERVER then
       
                                timer.Simple(0.01,function()
                            timer.Simple(1.47,function()
                            timer.Simple(0.34,function()
                        util.ScreenShake(grnd,100000,100000,4,1000)
                                local xplo = ents.Create("env_explosion")
                                xplo:SetPos(grnd)
                                xplo:SetKeyValue("iMagnitude","150")
                                xplo:Spawn()
                            xplo:Fire("Explode",0,0)
                            timer.Simple(0.01,function()
                                util.ScreenShake(grnd,100000,100000,4,1000)
                            local xplo = ents.Create("env_explosion")
                            xplo:SetPos(grnd)
                            xplo:SetKeyValue("iMagnitude","150")
                            xplo:Spawn()
                            xplo:Fire("Explode",0,0)
                            timer.Simple(0.01,function()
                                util.ScreenShake(grnd,100000,100000,4,1000)
                                local xplo = ents.Create("env_explosion")
                                xplo:SetPos(grnd)
                                xplo:SetKeyValue("iMagnitude","150")
                                xplo:Spawn()
                            xplo:Fire("Explode",0,0)
                            timer.Simple(0.01,function()
                                util.ScreenShake(grnd,100000,100000,4,1000)
                                local xplo = ents.Create("env_explosion")
                                xplo:SetPos(grnd)
                                xplo:SetKeyValue("iMagnitude","150")
                                xplo:Spawn()
                            xplo:Fire("Explode",0,0)
                            
                           
                            
                            end)
                            end)
                            end)
                            end)
                        	end)
                            end)
                            end

                            
                            
                            self.Owner:GetActiveWeapon():SetVar("nextaltfire",CurTime()+0.3)
                            end
                       

                            
