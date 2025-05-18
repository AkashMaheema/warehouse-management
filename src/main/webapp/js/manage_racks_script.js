
    $('#addForm').submit(function(e) {
        e.preventDefault();
        $.post('manageRacks', {
            action: 'create',
            rackName: $(this).find('[name=rackName]').val(),
            zoneId: $(this).find('[name=zoneId]').val(),
            rackCapacity: $(this).find('[name=rackCapacity]').val(),
            usedCapacity: $(this).find('[name=usedCapacity]').val()
        }, function() {
            location.reload();
        });
    });

    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=rackName]').val(row.find('.name').text());
        $('#editForm [name=zoneId]').val(row.find('td:nth-child(3)').text());
        $('#editForm [name=rackCapacity]').val(row.find('td:nth-child(4)').text());
        $('#editForm [name=usedCapacity]').val(row.find('td:nth-child(5)').text());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    $('#editForm').submit(function(e) {
        e.preventDefault();
        $.post('manageRacks', {
            action: 'update',
            id: $(this).find('[name=id]').val(),
            rackName: $(this).find('[name=rackName]').val(),
            zoneId: $(this).find('[name=zoneId]').val(),
            rackCapacity: $(this).find('[name=rackCapacity]').val(),
            usedCapacity: $(this).find('[name=usedCapacity]').val()
        }, function() {
            location.reload();
        });
    });

    $('.deleteBtn').click(function() {
        if (confirm("Are you sure?")) {
            const id = $(this).closest('tr').data('id');
            $.post('manageRacks', {
                action: 'delete',
                id: id
            }, function() {
                location.reload();
            });
        }
    });
