################################################################################
# Auteur : Spyrojojo
# Titre : Sparx Engine
# Description : Script pour l'aide a la conception d'un spyro like
################################################################################

module Vocab_sparx
  Reprendre = "Reprendre"
  Atlas = "Atlas"
  Charger = "Charger"
  Aide = "Aide"
  Quitter = "Quitter"
  Menu_pause = "Pause"
  Font.default_name = ["Copperplate Gothic Bold"]
  Font.default_size = 20
  Font.default_color = Color.new(198 ,145 ,54, 255)
  Font.default_outline = false
end

#=============================================================================================================================================
# Gestion des apparences et son
#=============================================================================================================================================

# Scene_Map------------------------------------------------------------------------------------------------------------------------------------
class Scene_Map
  alias_method :sparxmap_update, :update 
  def actor_change(id, name, index)
     $game_actors[id].character_name = name
     $game_actors[id].character_index = index
     $game_player.refresh
  end
  def update
    sparxmap_update
    $game_switches[11] = true # Gestion de sparx en event
    @region = $game_map.region_id($game_player.x , $game_player.y)
    @mov = Input.press?(:RIGHT) || Input.press?(:LEFT)
    if [1,2,3,4,5].include?(@region)
      actor_change(1, @mov ? "Spyro/$xpSPYROMARCHE" : "Spyro/$xpSPYROARRET", 0)
    else # Saut
      actor_change(1, "Spyro/$xpSPYROARRET", 0) 
    end
  end
end
#=============================================================================================================================================
# Gestion du menu principal
#=============================================================================================================================================

# Scene_MenuBase-------------------------------------------------------------------------------------------------------------------------
class Scene_MenuBase
  alias_method :sparx_start, :start
  def start
    sparx_start
    super
    create_background
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(0, 0, 0, 0)
  end
end

# Scene_Menu-------------------------------------------------------------------------------------------------------------------------------
class Scene_Menu
  def start
    super
    create_pau
    create_cmd
  end 
  def create_pau; @pause = Window_Pause.new; end
  def create_cmd
    @command = Window_Commands.new(Graphics.height / 2, Graphics.height / 2 -100)
    @command.set_handler(:reprendre, method(:reprendre))
    @command.set_handler(:atlas, method(:atlas))
    @command.set_handler(:aide, method(:aide))
    @command.set_handler(:quitter, method(:quitter))
    @command.set_handler(:charg, method(:charg))
    @command.set_handler(:cancel, method(:reprendre))
  end
    def reprendre; SceneManager.goto(Scene_Map); end
    def atlas; SceneManager.call(Scene_Atlas); end
    def aide; SceneManager.call(Scene_Help); end
    def charg; SceneManager.call(Scene_Load); end
    def quitter; SceneManager.exit; end
end
  
# Window_Commands-----------------------------------------------------------------------------------------------------------------------
class Window_Commands < Window_Command
    def make_command_list
    add_command(Vocab_sparx::Reprendre, :reprendre)
    add_command(Vocab_sparx::Atlas, :atlas)
    add_command(Vocab_sparx::Charger, :charg)
    add_command(Vocab_sparx::Aide, :aide)
    add_command(Vocab_sparx::Quitter, :quitter)
  end
end
# Window_Pause----------------------------------------------------------------------------------------------------------------------------
class Window_Pause < Window_Base  
  def initialize
    super(Graphics.height / 2, Graphics.height / 2 -141, 160, 45)
    self.contents.font.color = Color.new(198 ,145 ,54, 255)
    self.contents.draw_text(40, -4, 320, 32, Vocab_sparx::Menu_pause)
  end
end
