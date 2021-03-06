module Teach
  class InstructorsController < BaseController
    before_action :set_instructor, only: [:edit, :update, :destroy]
    responders :modal, :flash, :http_cache

    def new
      @instructor = Instructor.new
    end

    def create
      @instructor = Instructor.new(instructor_params)
      respond_with @instructor do |format|
        if @instructor.valid?
          @instructor.user = User.scoped.find_by(:email => @instructor.email)
          if @instructor.user && @instructor.save
            format.js { render 'reload' } #redirect_to teach_course_path(@course, show: 'people') 
          else
            format.js { render 'new' }
          end
        else
          format.js { render 'new' }
        end
      end
    end

    def edit
    end

    def update
      respond_with @instructor do |format|
        if @instructor.update(instructor_params)
          format.js { render 'reload' } #redirect_to teach_course_path(@course, show: 'people') 
        else
          format.js { render 'edit' }
        end
      end
    end

    def sort
      params[:instructor].each_with_index do |id, i|
        Instructor.where(:id => id).update_all(order: i + 1)
      end

      head :ok
    end

    def destroy
      @instructor.destroy
      respond_with @instructor do |format|
        format.html { redirect_to teach_course_path(@course, show: 'people') }
      end
    end

    private
      def set_instructor
        @instructor = Instructor.find(params[:id])
      end

      def instructor_params
        params.require(:instructor).permit(:course_id, :email, :role, :name, :title, :avatar, :about, :active, :order)
      end
  end
end
