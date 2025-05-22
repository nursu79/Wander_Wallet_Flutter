import { Router } from 'express';
import { promoteToAdmin } from '../controllers/adminController';
import { isAdmin } from '../middleware/isAdmin';

const router = Router();

// All admin routes require admin privileges
router.use(isAdmin);

// Promote a user to admin
router.post('/promote', promoteToAdmin);

export default router; 