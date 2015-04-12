################################################################################
# Auteur : Spyrojojo
# Titre : Sparx Engine
# Description : Script pour la conception d'un spyro like
################################################################################

module Sparx_config
  Font.default_name = ["Copperplate Gothic Bold"]
  Font.default_size = 20
  Font.default_color = Color.new(198 ,145 ,54, 255)
end

#--------------------------------------------------------------------------
# Scene_MenuBase
#--------------------------------------------------------------------------
class Scene_MenuBase
  alias_method :sparx_start, :start
  def start
    sparx_start
    super
    create_background
  end
  def picture_animation
    SS[1] = !SS[1] if [1,12].include?(SV[2])
    SS[1] ? SV[2] += 1 : SV[2] -= 1
    picture_show(2, "Aile/#{SV[2]}")
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(0, 0, 0, 0)
    @joyaux = Sprite.new
    @gemme = Sprite.new
    @joyaux.bitmap = Cache.picture("Interface/Joyaux")
    @gemme.bitmap = Cache.picture("Interface/Gemme")
  end
end

#--------------------------------------------------------------------------
# Scene_Menu
#--------------------------------------------------------------------------
class Scene_Menu
  def start
    super
    $lw = Graphics.width / 2; $hw = Graphics.height / 2
    create_pau
    create_cmd
  end
  
  def create_pau
    @pause = Window_Pause.new
  end
  
  def create_cmd
    @command = Window_Commands.new($lw-80, $hw-100)
    @command.set_handler(:reprendre, method(:reprendre))
    @command.set_handler(:atlas, method(:atlas))
    @command.set_handler(:aide, method(:aide))
    @command.set_handler(:quitter, method(:quitter))
    @command.set_handler(:cancel, method(:return_scene))
  end
  
    def reprendre; SceneManager.call(Scene_Map); end
    def atlas; SceneManager.call(Scene_Atlas); end
    def aide; SceneManager.call(Scene_Help); end
    def quitter; SceneManager.exit; end
end
  
#--------------------------------------------------------------------------
# Window_Commands
#--------------------------------------------------------------------------
class Window_Commands < Window_Command
    def make_command_list
    add_command("Reprendre", :reprendre)
    add_command("Atlas", :atlas)
    add_command("Aide", :aide)
    add_command("Quitter", :quitter)
  end
end

class Window_Pause < Window_Base  
  def initialize
    super($lw-80, $hw-146, 160, 50)
    self.contents.draw_text(40, 0, 320, 32, "Pause")
  end
end

#---------------------------------------------------------------------------
# Scene_Map
#---------------------------------------------------------------------------
class Scene_Map
  alias_method :sparxmap_update, :update 
  def actor_change(id, name, index)
     $game_actors[id].character_name = name
     $game_actors[id].character_index = index
     $game_player.refresh
  end
  def update
    sparxmap_update
    if Input.press?(:LEFT) or Input.press?(:RIGHT) 
      actor_change(1, "Spyro/$xpSPYROMARCHE", 0)
    else
      actor_change(1, "Spyro/$xpSPYROARRET", 0)
    end
  end
end
