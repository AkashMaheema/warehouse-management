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

    // Edit Button Click Handler
    $('.editBtn').click(function() {
        const row = $(this).closest('tr');
        $('#editForm [name=id]').val(row.data('id'));
        $('#editForm [name=rackName]').val(row.find('.name').text());
        $('#editForm [name=zoneId]').val(row.data('zone-id'));
        $('#editForm [name=rackCapacity]').val(row.find('td:nth-child(3)').text().trim());
        $('#editForm [name=usedCapacity]').val(row.find('td:nth-child(4)').text().trim());
        new bootstrap.Modal(document.getElementById('editModal')).show();
    });

    // Edit Form Submission Handler
    $('#editForm').submit(function(e) {
        e.preventDefault();

        const btn = $(this).find('button[type="submit"]');
        btn.prop('disabled', true);
        btn.html('<span class="spinner-border spinner-border-sm"></span> Updating...');

        $.ajax({
            url: 'manageRacks',
            type: 'POST',
            data: $(this).serialize() + '&action=update',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Close modal and refresh
                    $('#editModal').modal('hide');
                    showSuccessAlert(response.message || 'Rack updated successfully');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showErrorAlert(response.message || 'Update failed');
                }
            },
            error: function(xhr) {
                let message = 'Error communicating with server';
                try {
                    const response = JSON.parse(xhr.responseText);
                    message = response.message || message;
                } catch (e) {}
                showErrorAlert(message);
            },
            complete: function() {
                btn.prop('disabled', false);
                btn.html('Update');
            }
        });
    });

    // Helper functions for alerts
    function showSuccessAlert(message) {
        const alert = `<div class="alert alert-success alert-dismissible fade show position-fixed top-0 end-0 m-3">
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>`;
        $('body').append(alert);
        setTimeout(() => $('.alert-success').alert('close'), 3000);
    }

    function showErrorAlert(message) {
        const alert = `<div class="alert alert-danger alert-dismissible fade show position-fixed top-0 end-0 m-3">
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>`;
        $('body').append(alert);
        setTimeout(() => $('.alert-danger').alert('close'), 5000);
    }


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