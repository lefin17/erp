# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

#  using for sortable views
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def link_to_order(name, column, filter)
    if filter.soc == column
      name += "&nbsp;#{filter.sod == 'DESC' ? '&darr;' : '&uarr;'}"
      direction = filter.sod == 'DESC' ? 'ASC' : 'DESC'
    else
      direction = 'ASC'
    end
    link_to_function name, "applyFilter({soc: '#{column}', sod: '#{direction}'})"
  end

	# returns name of the selected item by its identifier
	def get_item_name_by_id(collection, item)
		selected = collection.detect { |i| i[1] == item }

		if selected
			selected[0]
		else
			''
		end
	end

	def format_dt(dt)
		dt.getlocal.strftime("%d.%m.%Y в %H:%M:%S")
	end

	def relative_date dt, need_time = true
		return 'неизвестно' unless dt.present?

		monthes = ['Нулября', 'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря']

		dtnow = Time.now

		if dt.year != dtnow.year
			return dt.day.to_s + ' ' + monthes[dt.month] + ' ' + dt.year.to_s + (need_time ? (' в ' + dt.hour.to_s + ':' + dt.strftime('%M')) : '')
		else
			time = need_time ? (' в ' + dt.hour.to_s + ':' + dt.strftime('%M')) : ''

			# is today?
			if (dt.month == dtnow.month) && (dt.day == dtnow.day)
				return 'сегодня' + time
			end

			# is yesterday?
			if (dt.month == dtnow.month) && (dt.day == dtnow.day - 1)
				return 'вчера' + time
			end

			# is tomorrow?
			if (dt.month == dtnow.month) && (dt.day == dtnow.day + 1)
				return 'завтра' + time
			end
		end

		# if no rules found -- return for this year
		return dt.day.to_s + ' ' + monthes[dt.month] + (need_time ? (' в ' + dt.hour.to_s + ':' + dt.strftime('%M')) : '')
  end

  def printable_link(object, options = {})
    render :partial => 'print_forms/printable_link', :locals => {:printable_object => object, :options => options}
  end

  def fast_links(container, collection)
    collection.map{ |c|
      content_tag :a, c, :href => 'javascript:void(0)', :container_id => container, :class => 'fast_link'
    }.join(', ')
  end
end

def color_picker
  {'clBlack' => '#000000',
  'clMaroon' => '#000080',
  'clGreen' => '#008000',
  'clOlive' => '#008080',
  'clNavy' => '#800000',
  'clPurple' => '#800080',
  'clTeal' => '#808000',
  'clGray' => '#808080',
  'clSilver' => '#C0C0C0',
  'clRed' => '#0000FF',
  'clLime' => '#00FF00',
  'clYellow' => '#00FFFF',
  'clBlue' => '#FF0000',
  'clFuchsia' => '#FF00FF',
  'clAqua' => '#FFFF00',
  'clLtGray' => '#C0C0C0',
  'clDkGray' => '#808080'}.collect { |n,v| [n,v] }
end