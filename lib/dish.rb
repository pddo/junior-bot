class Dish
  DAILY_MENU = YAML.load_file(File.join(APP_ROOT, 'config/daily_menu.yml'))

  def self.today_dishes
    wday = Time.now.strftime('%A')
    (DAILY_MENU[wday] || []).flatten
  end
end
