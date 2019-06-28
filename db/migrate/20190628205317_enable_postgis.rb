class EnablePostgis < ActiveRecord::Migration[5.2]
  def up
    enable_extension("postgis")
  end

  def down
    disable_extension("postgis")
  end
end