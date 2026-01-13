// Configuration de l'API
// En production, cette valeur peut être surchargée par Railway
export const API_URL = process.env.REACT_APP_API_URL || 
                       (process.env.NODE_ENV === 'production' 
                         ? 'https://multidrive-backend-565974867635.europe-west1.run.app'
                         : 'http://localhost:8000');

