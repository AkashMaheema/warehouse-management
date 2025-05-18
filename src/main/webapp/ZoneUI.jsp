<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="template/layout.jsp">
    <jsp:param name="title" value="ZoneUI" />
    <jsp:param name="activePage" value="ZoneUI" />
    <jsp:param name="content" value="ZoneUI" />
</jsp:include>
<html>
<head>
    <title>Zone Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --gray-color: #6c757d;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
        }

        .zone-card {
            cursor: pointer;
            transition: var(--transition);
            height: 200px;
            border-radius: var(--border-radius);
            border: 1px solid #e0e0e0;
            position: relative;
            background: white;
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }

        .zone-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }

        .zone-name {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 12px;
            color: var(--dark-color);
        }

        .capacity-meter {
            height: 10px;
            background: #e9ecef;
            margin: 12px 0;
            border-radius: 5px;
            overflow: hidden;
        }

        .used-capacity {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), var(--primary-color));
            transition: width 0.6s ease;
        }

        .add-zone-btn {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px dashed #ced4da;
            transition: var(--transition);
            background-color: rgba(248, 249, 250, 0.5);
        }

        .add-zone-btn:hover {
            background-color: rgba(233, 236, 239, 0.7);
            border-color: var(--primary-color);
        }

        .add-zone-btn svg {
            transition: var(--transition);
        }

        .add-zone-btn:hover svg {
            fill: var(--primary-color);
            transform: scale(1.1);
        }

        .action-dropdown {
            position: absolute;
            top: 12px;
            right: 12px;
            z-index: 10;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 50%;
            padding: 0;
            transition: var(--transition);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            color: var(--gray-color);
        }

        .action-btn:hover, .action-btn:focus {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: rotate(90deg);
        }

        .dropdown-menu {
            min-width: 140px;
            border-radius: var(--border-radius);
            border: 1px solid rgba(0,0,0,0.1);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 0.5rem 0;
            animation: fadeInDown 0.3s ease-out;
        }

        .dropdown-item {
            padding: 0.5rem 1.5rem;
            transition: var(--transition);
            font-size: 0.9rem;
        }

        .dropdown-item:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary-color);
        }

        .dropdown-item:active {
            background-color: var(--primary-color);
            color: white;
        }

        .dropdown-divider {
            border-top: 1px solid rgba(0,0,0,0.05);
            margin: 0.3rem 0;
        }

        .modal-content {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .modal-header {
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 1.2rem 1.5rem;
        }

        .modal-footer {
            border-top: 1px solid rgba(0,0,0,0.05);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        h1 {
            color: var(--dark-color);
            font-weight: 700;
            margin-bottom: 2rem;
            position: relative;
            display: block;
            text-align: center;
        }

        h1::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .status-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            font-size: 0.7rem;
            padding: 0.25rem 0.5rem;
            border-radius: 50px;
            font-weight: 600;
        }

        .status-active {
            background-color: rgba(76, 201, 240, 0.2);
            color: var(--success-color);
        }
    </style>
</head>
<div class="container">
        <h2 class="category-heading">Zone Management</h2>

    <div class="row">
        <!-- Add Zone Card -->
        <div class="col-lg-3 col-md-6 mb-4 animate__animated animate__fadeInUp">
            <div class="zone-card add-zone-btn" data-bs-toggle="modal" data-bs-target="#addModal">
                <div class="text-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="#6c757d" viewBox="0 0 16 16">
                        <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                    </svg>
                    <div class="mt-2 text-muted">Add New Zone</div>
                </div>
            </div>
        </div>

        <!-- Zone Cards -->
        <c:forEach var="zone" items="${zones}" varStatus="loop">
            <div class="col-lg-3 col-md-6 mb-4 animate__animated animate__fadeInUp" style="animation-delay: ${loop.index * 0.1}s">
                <div class="zone-card p-4">
                    <!-- Status Badge -->
                    <span class="status-badge status-active">
                            ${(zone.usedCapacity/zone.zoneCapacity)*100 < 80 ? 'Active' : 'Full'}
                    </span>

                    <!-- Action Dropdown -->
                    <div class="action-dropdown dropdown">
                        <button class="action-btn dropdown-toggle"
                                data-bs-toggle="dropdown"
                                aria-expanded="false"
                                onclick="event.stopPropagation()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
                            </svg>
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <a class="dropdown-item d-flex align-items-center" href="#"
                                   data-bs-toggle="modal"
                                   data-bs-target="#editModal"
                                   onclick="prepareEditModal(${zone.zoneId}, '${zone.zoneName}', ${zone.zoneCapacity}, ${zone.usedCapacity}); event.stopPropagation()">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                        <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5L13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175l-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                                    </svg>
                                    Edit
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center text-danger" href="#"
                                   onclick="deleteZone(${zone.zoneId}); event.stopPropagation()">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                        <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                                        <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4L4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                    </svg>
                                    Delete
                                </a>
                            </li>
                        </ul>
                    </div>

                    <!-- Zone Content -->
                    <div onclick="window.location.href='manageRacks?view=grid&zoneId=${zone.zoneId}'">
                        <div class="zone-name text-center">${zone.zoneName}</div>
                        <div class="text-center">
                            <div class="mb-1 text-muted">Capacity: ${zone.zoneCapacity} kg</div>
                            <div class="mb-1 text-muted">Used: ${zone.usedCapacity} kg</div>
                            <div class="capacity-meter">
                                <div class="used-capacity"
                                     style="width: ${(zone.usedCapacity/zone.zoneCapacity)*100}%">
                                </div>
                            </div>
                            <div class="mt-2 small text-muted">
                                    ${String.format("%.1f", (zone.usedCapacity/zone.zoneCapacity)*100)}% utilized
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Add Zone Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <form id="addForm" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Zone</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="zoneName" class="form-label">Zone Name</label>
                    <input type="text" id="zoneName" name="name" class="form-control" placeholder="Enter zone name" required/>
                </div>
                <div class="mb-3">
                    <label for="zoneCapacity" class="form-label">Total Capacity (kg)</label>
                    <input type="number" id="zoneCapacity" name="capacity" class="form-control" placeholder="Enter total capacity" required/>
                </div>
                <div class="mb-3">
                    <label for="zoneUsed" class="form-label">Used Capacity (kg)</label>
                    <input type="number" id="zoneUsed" name="used" class="form-control" placeholder="Enter used capacity" required/>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Zone</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Zone Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <form id="editForm" class="modal-content">
            <input type="hidden" name="id" id="editZoneId"/>
            <div class="modal-header">
                <h5 class="modal-title">Edit Zone</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="editZoneName" class="form-label">Zone Name</label>
                    <input type="text" id="editZoneName" name="name" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label for="editZoneCapacity" class="form-label">Total Capacity (kg)</label>
                    <input type="number" id="editZoneCapacity" name="capacity" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label for="editZoneUsed" class="form-label">Used Capacity (kg)</label>
                    <input type="number" id="editZoneUsed" name="used" class="form-control" required/>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Zone</button>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Add Zone Form
    $('#addForm').submit(function(e) {
        e.preventDefault();
        $.post('manageZone', {
            action: 'create',
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => {
            // Show success animation before reload
            $('.animate__animated').addClass('animate__fadeOut');
            setTimeout(() => location.reload(), 500);
        });
    });

    // Edit Zone Form
    $('#editForm').submit(function(e) {
        e.preventDefault();
        $.post('manageZone', {
            action: 'update',
            id: this.id.value,
            name: this.name.value,
            capacity: this.capacity.value,
            used: this.used.value
        }, () => {
            // Show success animation before reload
            $('.animate__animated').addClass('animate__fadeOut');
            setTimeout(() => location.reload(), 500);
        });
    });

    // Prepare Edit Modal
    function prepareEditModal(id, name, capacity, used) {
        $('#editZoneId').val(id);
        $('#editZoneName').val(name);
        $('#editZoneCapacity').val(capacity);
        $('#editZoneUsed').val(used);

        // Animate modal appearance
        $('#editModal').on('shown.bs.modal', function() {
            $(this).find('.modal-content').addClass('animate__animated animate__fadeInUp');
        });
    }

    // Delete Zone with confirmation and animation
    function deleteZone(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4361ee',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $.post('manageZone', {
                    action: 'delete',
                    id: id
                }, () => {
                    // Animate card removal before reload
                    $(`div[data-zone-id="${id}"]`).addClass('animate__animated animate__fadeOut');
                    setTimeout(() => location.reload(), 500);
                });
            }
        });
    }

    // Initialize tooltips
    $(function () {
        $('[data-bs-toggle="tooltip"]').tooltip();
    });

    // Prevent card click when interacting with dropdown
    $('.dropdown-menu').click(function(e) {
        e.stopPropagation();
    });

    // Add animation to modals when they appear
    $('.modal').on('show.bs.modal', function() {
        $(this).find('.modal-content').addClass('animate__animated animate__fadeInUp');
    });
</script>
</body>
</html>