################################################################################
# Titre : Menu BGM et BGS
# Auteur : Spyrojojo
# Version  : 2.2
# Aide : Nuki , Joke
################################################################################
 
module Spyro_Sound
  
  ### CONFIGURATION
  Activation_BGM = true      # Joue un BGM dans le menu si true
  Choix_BGM = "Theme1"       # Titre du BGM
  Bgm_Volume = 80            # Volume du BGM (ne pas dépasser 100)
  Bgm_Pitch = 150            # Vitesse du BGM (entre 50 et 150)
  Activation_BGS = false     # Joue un BGS dans le menu si true
  Choix_BGS = "Fire"         # Titre du BGS
  Bgs_Volume = 80            # Volume du BGS
  Bgs_Pitch = 100            # Vitesse du BGS (entre 50 et 150)
  Menu_Reprise_Fondu = true  # Reprise en fondu des BGM et BGS de la map si true
 
  ### Ne pas toucher
  def self.Bgm
    RPG::BGM.new(Choix_BGM, Bgm_Volume, Bgm_Pitch).play
  end
  def self.Bgs
    RPG::BGS.new(Choix_BGS, Bgs_Volume, Bgs_Pitch).play
  end
end
 
class Scene_MenuBase
  alias_method :spyro_start, :start
  alias_method :spyro_pre_terminate, :pre_terminate
  alias_method :spyro_update, :update
  def start
    spyro_start
    @last_bgm = RPG::BGM.last
    @last_bgs = RPG::BGS.last
  end
def update
  spyro_update
end
def pre_terminate
    spyro_pre_terminate
    Spyro_Sound::Menu_Reprise_Fondu ? @last_bgm.replay : @last_bgm.play
    Spyro_Sound::Menu_Reprise_Fondu ? @last_bgs.replay : @last_bgs.play  
  end
end
 
class Scene_Map
  alias_method :spyro_pre_terminate, :pre_terminate
  def pre_terminate
      spyro_pre_terminate
      Spyro_Sound.Bgm if Spyro_Sound::Activation_BGM 
      Spyro_Sound.Bgs if Spyro_Sound::Activation_BGS
    end
end
