<h1>Listing groups</h1>
<%= link_to 'New Group', new_group_path, :class => 'btn small success' %>
<table>
  <tr>
    <th>Group name</th>
    <th>Group ID</th>
    <th></th>
    <th></th>
    <th></th>
  </tr>

<% @groups.each do |group| %>
  <tr>
    <td><%= group.name %></td>
    <td><%= group.id %></td>
    <td><%= link_to 'Show', group %></td>
    <td><%= link_to 'Edit', edit_group_path(group) %></td>
    <td><%= link_to 'Destroy', group, :confirm => 'Are you sure?', :method => :delete %></td>
  </tr>
<% end %>
</table>

<br />


