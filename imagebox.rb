# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'penguin.rb')

class Gtk::ImageBox
  attr_accessor :left
  attr_accessor :right
  attr_reader :filename

  def set_filename(filename)
    @filename = filename
    redraw
  end

  def redraw
    image_file = if @filename
      @filename 
    else
      @noimage_file
    end

    if @image_widget.child
      @image_widget.remove(@image_widget.child)
    end

    @image_widget.add(Gtk::WebIcon.new(image_file, 100, 100)).show_all
  end

  def swap_left_image
    if @left
      filename_tmp = @left.filename

      @left.set_filename(@filename)
      set_filename(filename_tmp)
    end
  end


  def swap_right_image
    if @right
      filename_tmp = @right.filename

      @right.set_filename(@filename)
      set_filename(filename_tmp)
    end
  end

  def delete_image
    @filename = nil
    redraw
  end

  def initialize(filename, noimage_file)
    @filename = filename
    @noimage_file = noimage_file
  end

  def widget
    if !@image_container
      @image_container = Gtk::Box.new(:vertical)
      @image_container.width_request = 100

      button_left = Gtk::Button.new.add(Gtk::WebIcon.new(Skin.get('arrow_notfollowed.png'), 16, 16))

      button_left.ssc(:clicked) { |w, e|
        swap_left_image
      }

      button_delete = Gtk::Button.new.add(Gtk::WebIcon.new(Skin.get('close.png'), 16, 16))

      button_delete.ssc(:clicked) { |w, e|
        delete_image
      }
      
      button_right = Gtk::Button.new.add(Gtk::WebIcon.new(Skin.get('arrow_notfollowing.png'), 16, 16))

      button_right.ssc(:clicked) { |w, e|
        swap_right_image
      }

      @image_widget = Gtk::EventBox.new

      @image_widget.ssc(:button_press_event) { |w, e|
        choose_image_file(false) { |filenames_tmp|
          filename = if filenames_tmp
            filenames_tmp.first
          else
            nil
          end

          set_filename(filename)
        }
      }

      @image_container.pack_start(@image_widget, expand: true)
 
      buttonbox = Gtk::Box.new(:horizontal)

      buttonbox.pack_start(button_left, expand: false)
      buttonbox.pack_start(button_delete, expand: true)
      buttonbox.pack_start(button_right, expand: false)

      @image_container.pack_start(buttonbox, expand: false)

      redraw
    end

    @image_container
  end
end
