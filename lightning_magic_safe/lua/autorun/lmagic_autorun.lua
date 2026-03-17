game.AddParticles("particles/teslacoil/teslacoil_orb.pcf")
PrecacheParticleSystem("teslacoil_orb")
PrecacheParticleSystem("teslacoil_orb_beam")
PrecacheParticleSystem("teslacoil_orb_blast")

sound.Add(
{
	name = "Weapon_Dystopia_Sparky.Charge",
	channel = CHAN_AUTO,
	level = 70,
	volume = 0.7,
	sound = "dystopia/weapons/tesla/fire.wav"
} )
sound.Add(
{
	name = "Weapon_Dystopia_Sparky.AltCharge",
	channel = CHAN_AUTO,
	level = 100,
	sound = "dystopia/weapons/tesla/alt_fire.wav"
} )
sound.Add(
{
	name = "Weapon_Dystopia_Sparky.Draw",
	channel = CHAN_AUTO,
	sound = "dystopia/weapons/tesla/tesla_draw.wav"
} )
sound.Add(
{
	name = "Weapon_Dystopia_Sparky.Empty",
	channel = CHAN_AUTO,
	sound = "dystopia/weapons/tesla/tesla_empty.wav"
} )

sound.Add(
{
	name = "teslaorb_idle",
	channel = CHAN_AUTO,
	sound = "weapon_teslacoil/teslaorb_idle.wav"
} )

sound.Add(
{
	name = "teslaorb_blast",
	channel = CHAN_AUTO,
	sound = "weapon_teslacoil/teslaorb_blast.wav"
} )
