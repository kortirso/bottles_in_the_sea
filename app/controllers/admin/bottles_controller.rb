# frozen_string_literal: true

module Admin
  class BottlesController < AdminController
    include Pagy::Backend

    before_action :find_bottles, only: %i[index]
    before_action :find_bottle, except: %i[index]

    def index; end

    def approve
      @bottle.update!(moderated_at: DateTime.now)
      redirect_to admin_bottles_path
    end

    def destroy
      @bottle.destroy
      redirect_to admin_bottles_path
    end

    private

    def find_bottles
      @pagy, @bottles = pagy(Bottle.includes(:files_attachments, :cell, start_cell: :world).order(id: :desc))
    end

    def find_bottle
      @bottle = Bottle.find(params[:id])
    end
  end
end
