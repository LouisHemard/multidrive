import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';
import { API_URL } from './config';

function App() {
  const [garages, setGarages] = useState([]);
  const [vehicles, setVehicles] = useState([]);
  const [selectedGarage, setSelectedGarage] = useState(null);
  const [showVehicleForm, setShowVehicleForm] = useState(false);
  const [editingVehicle, setEditingVehicle] = useState(null);
  const [movingVehicle, setMovingVehicle] = useState(null);
  const [targetGarageId, setTargetGarageId] = useState(null);
  const [vehicleForm, setVehicleForm] = useState({
    brand: '',
    model: '',
    year: new Date().getFullYear(),
    license_plate: '',
    garage_id: null
  });

  useEffect(() => {
    fetchGarages();
    fetchVehicles();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const fetchGarages = async () => {
    try {
      const response = await axios.get(`${API_URL}/garages`);
      setGarages(response.data);
      if (response.data.length > 0 && !selectedGarage) {
        setSelectedGarage(response.data[0].id);
      }
    } catch (error) {
      console.error('Error fetching garages:', error);
    }
  };

  const fetchVehicles = async () => {
    try {
      const response = await axios.get(`${API_URL}/vehicles`);
      setVehicles(response.data);
    } catch (error) {
      console.error('Error fetching vehicles:', error);
    }
  };

  const handleAddVehicle = async (e) => {
    e.preventDefault();
    if (!selectedGarage) {
      alert('Sélectionnez un garage');
      return;
    }

    try {
      await axios.post(`${API_URL}/vehicles`, {
        ...vehicleForm,
        garage_id: selectedGarage
      });
      setVehicleForm({
        brand: '',
        model: '',
        year: new Date().getFullYear(),
        license_plate: '',
        garage_id: null
      });
      setShowVehicleForm(false);
      fetchVehicles();
    } catch (error) {
      console.error('Error adding vehicle:', error);
      alert('Erreur lors de l\'ajout du véhicule');
    }
  };

  const handleEditVehicle = (vehicle) => {
    setEditingVehicle(vehicle.id);
    setVehicleForm({
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      license_plate: vehicle.license_plate,
      garage_id: vehicle.garage_id
    });
    setShowVehicleForm(true);
  };

  const handleUpdateVehicle = async (e) => {
    e.preventDefault();
    if (!selectedGarage) {
      alert('Sélectionnez un garage');
      return;
    }

    try {
      await axios.put(`${API_URL}/vehicles/${editingVehicle}`, {
        ...vehicleForm,
        garage_id: selectedGarage
      });
      setVehicleForm({
        brand: '',
        model: '',
        year: new Date().getFullYear(),
        license_plate: '',
        garage_id: null
      });
      setEditingVehicle(null);
      setShowVehicleForm(false);
      fetchVehicles();
    } catch (error) {
      console.error('Error updating vehicle:', error);
      alert('Erreur lors de la modification du véhicule');
    }
  };

  const cancelEdit = () => {
    setEditingVehicle(null);
    setVehicleForm({
      brand: '',
      model: '',
      year: new Date().getFullYear(),
      license_plate: '',
      garage_id: null
    });
    setShowVehicleForm(false);
  };

  const handleDeleteVehicle = async (id) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer ce véhicule?')) {
      return;
    }

    try {
      await axios.delete(`${API_URL}/vehicles/${id}`);
      fetchVehicles();
    } catch (error) {
      console.error('Error deleting vehicle:', error);
      alert('Erreur lors de la suppression');
    }
  };

  const handleMoveVehicle = (vehicle) => {
    setMovingVehicle(vehicle);
    setTargetGarageId(null);
  };

  const confirmMoveVehicle = async () => {
    if (!targetGarageId) {
      alert('Veuillez sélectionner un garage de destination');
      return;
    }

    if (targetGarageId === movingVehicle.garage_id) {
      alert('Le véhicule est déjà dans ce garage');
      setMovingVehicle(null);
      return;
    }

    try {
      await axios.put(`${API_URL}/vehicles/${movingVehicle.id}`, {
        brand: movingVehicle.brand,
        model: movingVehicle.model,
        year: movingVehicle.year,
        license_plate: movingVehicle.license_plate,
        garage_id: targetGarageId
      });
      setMovingVehicle(null);
      setTargetGarageId(null);
      fetchVehicles();
      // Si le véhicule a été déplacé vers un autre garage, on reste sur le garage actuel
    } catch (error) {
      console.error('Error moving vehicle:', error);
      alert('Erreur lors du déplacement du véhicule');
    }
  };

  const cancelMoveVehicle = () => {
    setMovingVehicle(null);
    setTargetGarageId(null);
  };

  const filteredVehicles = vehicles.filter(v => v.garage_id === selectedGarage);
  const currentGarage = garages.find(g => g.id === selectedGarage);

  return (
    <div className="App">
      <header className="App-header">
        <h1>🚗 MultiDrive</h1>
      </header>

      <div className="container">
        <div className="sidebar">
          <h2>Garages</h2>
          <div className="garage-list">
            {garages.map(garage => (
              <div
                key={garage.id}
                className={`garage-item ${selectedGarage === garage.id ? 'active' : ''}`}
                onClick={() => setSelectedGarage(garage.id)}
              >
                <div className="garage-icon">🚗</div>
                <div className="garage-info">
                  <div className="garage-name">{garage.name}</div>
                  <div className="garage-address">{garage.address}</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="main-content">
          {currentGarage && (
            <>
              <div className="content-header">
                <h2>Véhicules - {currentGarage.name}</h2>
                <button 
                  className="btn-primary"
                  onClick={() => setShowVehicleForm(!showVehicleForm)}
                >
                  {showVehicleForm ? 'Annuler' : '+ Ajouter un véhicule'}
                </button>
              </div>

              {showVehicleForm && (
                <div className="vehicle-form">
                  <h3>{editingVehicle ? 'Modifier le véhicule' : 'Nouveau véhicule'}</h3>
                  <form onSubmit={editingVehicle ? handleUpdateVehicle : handleAddVehicle}>
                    <div className="form-row">
                      <div className="form-group">
                        <label>Marque</label>
                        <input
                          type="text"
                          value={vehicleForm.brand}
                          onChange={(e) => setVehicleForm({...vehicleForm, brand: e.target.value})}
                          required
                        />
                      </div>
                      <div className="form-group">
                        <label>Modèle</label>
                        <input
                          type="text"
                          value={vehicleForm.model}
                          onChange={(e) => setVehicleForm({...vehicleForm, model: e.target.value})}
                          required
                        />
                      </div>
                    </div>
                    <div className="form-row">
                      <div className="form-group">
                        <label>Année</label>
                        <input
                          type="number"
                          value={vehicleForm.year}
                          onChange={(e) => setVehicleForm({...vehicleForm, year: parseInt(e.target.value)})}
                          required
                        />
                      </div>
                      <div className="form-group">
                        <label>Plaque d'immatriculation</label>
                        <input
                          type="text"
                          value={vehicleForm.license_plate}
                          onChange={(e) => setVehicleForm({...vehicleForm, license_plate: e.target.value})}
                          required
                        />
                      </div>
                    </div>
                    <div style={{ display: 'flex', gap: '1rem' }}>
                      <button type="submit" className="btn-submit">
                        {editingVehicle ? 'Modifier' : 'Ajouter'}
                      </button>
                      <button type="button" className="btn-cancel" onClick={cancelEdit}>
                        Annuler
                      </button>
                    </div>
                  </form>
                </div>
              )}

              <div className="vehicles-list">
                {filteredVehicles.length === 0 ? (
                  <div className="empty-state">
                    <p>Aucun véhicule dans ce garage</p>
                  </div>
                ) : (
                  filteredVehicles.map(vehicle => (
                    <div key={vehicle.id} className="vehicle-card">
                      <div className="vehicle-info">
                        <div className="vehicle-brand">{vehicle.brand}</div>
                        <div className="vehicle-model">{vehicle.model}</div>
                        <div className="vehicle-details">
                          <span>Année: {vehicle.year}</span>
                          <span>Plaque: {vehicle.license_plate}</span>
                        </div>
                      </div>
                      <div style={{ display: 'flex', gap: '0.5rem' }}>
                        <button
                          className="btn-move"
                          onClick={() => handleMoveVehicle(vehicle)}
                        >
                          Déplacer
                        </button>
                        <button
                          className="btn-edit"
                          onClick={() => handleEditVehicle(vehicle)}
                        >
                          Modifier
                        </button>
                        <button
                          className="btn-delete"
                          onClick={() => handleDeleteVehicle(vehicle.id)}
                        >
                          Supprimer
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </>
          )}
        </div>
      </div>

      {movingVehicle && (
        <div className="modal-overlay" onClick={cancelMoveVehicle}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <h3>Déplacer le véhicule</h3>
            <p>
              <strong>{movingVehicle.brand} {movingVehicle.model}</strong>
              <br />
              Plaque: {movingVehicle.license_plate}
            </p>
            <div className="form-group">
              <label>Sélectionnez le garage de destination :</label>
              <select
                value={targetGarageId || ''}
                onChange={(e) => setTargetGarageId(parseInt(e.target.value))}
                className="form-select"
              >
                <option value="">-- Sélectionner un garage --</option>
                {garages.map(garage => (
                  <option key={garage.id} value={garage.id}>
                    {garage.name} - {garage.address}
                  </option>
                ))}
              </select>
            </div>
            <div style={{ display: 'flex', gap: '1rem', marginTop: '1rem' }}>
              <button
                type="button"
                className="btn-submit"
                onClick={confirmMoveVehicle}
              >
                Déplacer
              </button>
              <button
                type="button"
                className="btn-cancel"
                onClick={cancelMoveVehicle}
              >
                Annuler
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default App;

