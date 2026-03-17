--Info
SWEP.PrintName		= 'Lightning Magic (SAFE)'
SWEP.Author			= 'Sevv'
SWEP.Category 		= "Magic"

--SpawnInfo
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModelFOV = 70


--Clip Info
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.Radius			= 20
SWEP.Primary.Damage			= 1000

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Recoil		= 2

--More Info
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair		= true
SWEP.LightningStrike = 0

--Models

SWEP.UseHands 			 = false
SWEP.HoldType             = "magic"
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.UseHands = false
SWEP.IconOverride = "materials/icon/lmagicicon.png"
if CLIENT then 

function SWEP:DoImpactEffect( tr )
	if tr.HitSky then return end
	local eData = EffectData()
	if tr.Entity:IsValid() and ( tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() ) then
		eData:SetEntity( tr.Entity )
		eData:SetMagnitude(3)
		util.Effect( "TeslaHitboxes", eData, true, true )
	else
		local eData = EffectData()
		eData:SetOrigin( tr.HitPos )
		eData:SetStart( tr.HitPos )
		eData:SetMagnitude(2)
		eData:SetAngles(Angle(110,110,110))
		util.Effect( "ElectricSpark", eData )
	end
end
end



function SWEP:ShootEffects()

	return true

end

function SWEP:CanPrimaryAttack()

	
	
	return true
	
end

function SWEP:CanSecondaryAttack()

	
	
	return true
	
end
