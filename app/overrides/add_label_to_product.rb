# frozen_string_literal: true

class AddLabelToProduct
  Deface::Override.new(
    virtual_path: 'spree/admin/products/_form',
    name: 'add_label_to_product',
    insert_after: "div[data-hook='admin_product_form_tax_category']",
    text: <<-HTML
    <%- unless @product.labels.blank? %>
      <%- @product.labels.each do |label| %>
        <div class="table-responsive border rounded bg-white">
          <table class="table">
            <thead class="text-muted text-center">
              <tr>
                <th><%= t('spree.admin.label_name') %></th>
                <th><%= t('spree.admin.position') %></th>
                <th><%= t('spree.admin.status') %></th>
                <th><%= t('spree.admin.start_date') %></th>
                <th><%= t('spree.admin.end_date') %></th>
              </tr>
            </thead>
            <tbody class="text-center">
              <tr>
                <td><%= label.name %></td>
                <td><%= label.position %></td>
                <td>
                  <% if label.active %>
                    <span class="badge bg-success text-white"><%= t('spree.admin.active') %></span>
                  <% else %>
                    <span class="badge bg-danger text-white"><%= t('spree.admin.inactive') %></span>
                  <% end %>
                </td>
                <td>
                  <%- if label.end_date.nil? %>
                    <span class="badge bg-success text-white px-3 py-1 rounded-pill">∞</span>
                  <%- else %>
                    <%= label.start_date.strftime('%Y-%m-%d') %>
                  <% end %>
                <td>
                  <%- if label.end_date.nil? %>
                    <span class="badge bg-success text-white px-3 py-1 rounded-pill">∞</span>
                  <%- else %>
                    <%= label.end_date.strftime('%Y-%m-%d') %>
                  <% end %>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      <% end %>
    <% end %>
    HTML
  )
end
