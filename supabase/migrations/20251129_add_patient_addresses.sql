-- Create patient_addresses table for storing patient location information
CREATE TABLE IF NOT EXISTS public.patient_addresses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Location coordinates
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,

    -- Address details
    address_line TEXT NOT NULL,
    apartment_number TEXT,
    floor TEXT,
    door_number TEXT,
    entrance TEXT,
    building_name TEXT,
    additional_info TEXT,

    -- Metadata
    label TEXT, -- e.g., "Home", "Work", "Parent's House"
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_patient_addresses_user_id ON public.patient_addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_patient_addresses_default ON public.patient_addresses(user_id, is_default) WHERE is_default = true;

-- Enable Row Level Security
ALTER TABLE public.patient_addresses ENABLE ROW LEVEL SECURITY;

-- RLS Policies for patient_addresses

-- Patients can view their own addresses
CREATE POLICY "Patients can view own addresses"
    ON public.patient_addresses
    FOR SELECT
    USING (auth.uid() = user_id);

-- Patients can insert their own addresses
CREATE POLICY "Patients can insert own addresses"
    ON public.patient_addresses
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Patients can update their own addresses
CREATE POLICY "Patients can update own addresses"
    ON public.patient_addresses
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Patients can delete their own addresses
CREATE POLICY "Patients can delete own addresses"
    ON public.patient_addresses
    FOR DELETE
    USING (auth.uid() = user_id);

-- Doctors can view patient addresses for their accepted requests
CREATE POLICY "Doctors can view patient addresses for their requests"
    ON public.patient_addresses
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1
            FROM public.test_requests tr
            INNER JOIN public.profiles p ON p.user_id = auth.uid()
            WHERE tr.patient_id = patient_addresses.user_id
                AND tr.doctor_id = auth.uid()
                AND p.role = 'doctor'
                AND tr.status IN ('accepted', 'on_the_way', 'sample_collected', 'delivered_to_lab', 'completed')
        )
    );

-- Function to ensure only one default address per user
CREATE OR REPLACE FUNCTION public.ensure_single_default_address()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_default = true THEN
        UPDATE public.patient_addresses
        SET is_default = false
        WHERE user_id = NEW.user_id AND id != NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to maintain single default address
CREATE TRIGGER trigger_ensure_single_default_address
    BEFORE INSERT OR UPDATE ON public.patient_addresses
    FOR EACH ROW
    WHEN (NEW.is_default = true)
    EXECUTE FUNCTION public.ensure_single_default_address();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_patient_address_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at
CREATE TRIGGER trigger_update_patient_address_timestamp
    BEFORE UPDATE ON public.patient_addresses
    FOR EACH ROW
    EXECUTE FUNCTION public.update_patient_address_timestamp();
