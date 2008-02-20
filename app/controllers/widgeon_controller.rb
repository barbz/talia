class WidgeonController < ApplicationController
  def index
    if request.xhr?
      raise(ArgumentError, "Widget not found") unless Widgeon::Widget.loaded_widgets.include?(params[:widget_name].to_sym) 
      options = {:controller => @controller, :request => request}
      widget  = Widgeon::Widget.create_widget(params[:widget_name], options)
      render :text => widget.send(params[:handler].to_sym, params), :status => 200
    end
  end 
  
  # This handles a callback from a widget
  def callback
    options = WidgeonEncoding.decode_options(params[:widget_callback_options])
    
    widget_class = options.delete(:widget_class)
    
    @widget = Widgeon::Widget.load(widget_class.to_s).new(options)
  end
end