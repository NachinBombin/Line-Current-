include('shared.lua')

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if self:CanPrimaryAttack() then
		self:DoImpactEffect( tr )
	end
end

function SWEP:SecondaryAttack()
	return false
end

local TeslaBeam = Material( "effects/teslacoil_beam" )
local TeslaSpark = Material( "sprites/light_glow02_add" )
	
local function GetTracerShootPos( ply, ent, attach )
	if !IsValid( ent ) then return false end
	if !ent:IsWeapon() then return false end

	local pos = false

	if ent:IsCarriedByLocalPlayer() and GetViewEntity() == LocalPlayer() then    
		local ViewModel = LocalPlayer():GetViewModel()
		if IsValid( ViewModel ) then
		local att = ViewModel:GetAttachment( attach )
		if att then
		pos = att.Pos
			end
		end
	else
		local att = ent:GetAttachment( attach )
		if att then
			pos = att.Pos
		end
	end

	return pos
end

local function CreateLight(pos, numb, self)
	local dlight = DynamicLight( self:EntIndex() + numb )
	if ( dlight ) then
		dlight.r =  199
		dlight.g = 199
		dlight.b = math.Rand(199,255)

		dlight.Pos =  pos
		dlight.Brightness = math.Rand(0.4,0.6)
		dlight.Size = math.Rand(500,525)
		dlight.Decay = 1000
		dlight.DieTime = CurTime() + math.Rand(0.26,0.32)
	end
end

