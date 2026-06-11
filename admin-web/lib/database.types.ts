export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      audit_logs: {
        Row: {
          action: string
          created_at: string | null
          id: string
          ip_address: unknown
          new_data: Json | null
          old_data: Json | null
          record_id: string | null
          table_name: string
          user_agent: string | null
          user_id: string | null
        }
        Insert: {
          action: string
          created_at?: string | null
          id?: string
          ip_address?: unknown
          new_data?: Json | null
          old_data?: Json | null
          record_id?: string | null
          table_name: string
          user_agent?: string | null
          user_id?: string | null
        }
        Update: {
          action?: string
          created_at?: string | null
          id?: string
          ip_address?: unknown
          new_data?: Json | null
          old_data?: Json | null
          record_id?: string | null
          table_name?: string
          user_agent?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "audit_logs_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      doctor_availability: {
        Row: {
          created_at: string | null
          day_of_week: Database["public"]["Enums"]["availability_day"]
          doctor_id: string
          end_time: string
          id: string
          is_active: boolean | null
          start_time: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          day_of_week: Database["public"]["Enums"]["availability_day"]
          doctor_id: string
          end_time: string
          id?: string
          is_active?: boolean | null
          start_time: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          day_of_week?: Database["public"]["Enums"]["availability_day"]
          doctor_id?: string
          end_time?: string
          id?: string
          is_active?: boolean | null
          start_time?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "doctor_availability_doctor_id_fkey"
            columns: ["doctor_id"]
            isOneToOne: false
            referencedRelation: "doctor_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      doctor_profiles: {
        Row: {
          academic_degree: string | null
          bio: string | null
          certifications: Json | null
          created_at: string | null
          doctor_type: Database["public"]["Enums"]["doctor_type"] | null
          id: string
          is_available: boolean | null
          license_number: string
          photo_url: string | null
          preferred_areas: string[] | null
          profession: string | null
          professional_development: string | null
          rating: number | null
          total_completed_requests: number | null
          total_reviews: number | null
          updated_at: string | null
          work_experience_years: number | null
          years_of_experience: number | null
        }
        Insert: {
          academic_degree?: string | null
          bio?: string | null
          certifications?: Json | null
          created_at?: string | null
          doctor_type?: Database["public"]["Enums"]["doctor_type"] | null
          id: string
          is_available?: boolean | null
          license_number: string
          photo_url?: string | null
          preferred_areas?: string[] | null
          profession?: string | null
          professional_development?: string | null
          rating?: number | null
          total_completed_requests?: number | null
          total_reviews?: number | null
          updated_at?: string | null
          work_experience_years?: number | null
          years_of_experience?: number | null
        }
        Update: {
          academic_degree?: string | null
          bio?: string | null
          certifications?: Json | null
          created_at?: string | null
          doctor_type?: Database["public"]["Enums"]["doctor_type"] | null
          id?: string
          is_available?: boolean | null
          license_number?: string
          photo_url?: string | null
          preferred_areas?: string[] | null
          profession?: string | null
          professional_development?: string | null
          rating?: number | null
          total_completed_requests?: number | null
          total_reviews?: number | null
          updated_at?: string | null
          work_experience_years?: number | null
          years_of_experience?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "doctor_profiles_id_fkey"
            columns: ["id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      doctor_reviews: {
        Row: {
          communication_rating: number | null
          created_at: string | null
          doctor_id: string
          doctor_response: string | null
          helpful_count: number | null
          id: string
          is_verified: boolean | null
          is_visible: boolean | null
          not_helpful_count: number | null
          patient_id: string
          professionalism_rating: number | null
          punctuality_rating: number | null
          rating: number
          responded_at: string | null
          review_text: string | null
          review_title: string | null
          test_request_id: string | null
          updated_at: string | null
        }
        Insert: {
          communication_rating?: number | null
          created_at?: string | null
          doctor_id: string
          doctor_response?: string | null
          helpful_count?: number | null
          id?: string
          is_verified?: boolean | null
          is_visible?: boolean | null
          not_helpful_count?: number | null
          patient_id: string
          professionalism_rating?: number | null
          punctuality_rating?: number | null
          rating: number
          responded_at?: string | null
          review_text?: string | null
          review_title?: string | null
          test_request_id?: string | null
          updated_at?: string | null
        }
        Update: {
          communication_rating?: number | null
          created_at?: string | null
          doctor_id?: string
          doctor_response?: string | null
          helpful_count?: number | null
          id?: string
          is_verified?: boolean | null
          is_visible?: boolean | null
          not_helpful_count?: number | null
          patient_id?: string
          professionalism_rating?: number | null
          punctuality_rating?: number | null
          rating?: number
          responded_at?: string | null
          review_text?: string | null
          review_title?: string | null
          test_request_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "doctor_reviews_doctor_id_fkey"
            columns: ["doctor_id"]
            isOneToOne: false
            referencedRelation: "doctor_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "doctor_reviews_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "doctor_reviews_test_request_id_fkey"
            columns: ["test_request_id"]
            isOneToOne: false
            referencedRelation: "test_requests"
            referencedColumns: ["id"]
          },
        ]
      }
      doctor_services: {
        Row: {
          created_at: string | null
          doctor_id: string
          id: string
          is_available: boolean | null
          notes: string | null
          price_mnt: number
          service_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          doctor_id: string
          id?: string
          is_available?: boolean | null
          notes?: string | null
          price_mnt: number
          service_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          doctor_id?: string
          id?: string
          is_available?: boolean | null
          notes?: string | null
          price_mnt?: number
          service_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "doctor_services_doctor_id_fkey"
            columns: ["doctor_id"]
            isOneToOne: false
            referencedRelation: "doctor_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "doctor_services_service_id_fkey"
            columns: ["service_id"]
            isOneToOne: false
            referencedRelation: "services"
            referencedColumns: ["id"]
          },
        ]
      }
      laboratories: {
        Row: {
          address: string
          category_id: string | null
          cover_image_url: string | null
          created_at: string | null
          description: string | null
          description_mn: string | null
          district: string | null
          district_mn: string | null
          email: string | null
          id: string
          is_active: boolean | null
          latitude: number | null
          logo_url: string | null
          longitude: number | null
          name: string
          operating_hours: Json | null
          phone_number: string
          rating: number | null
          total_reviews: number | null
          updated_at: string | null
          website_url: string | null
        }
        Insert: {
          address: string
          category_id?: string | null
          cover_image_url?: string | null
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          district?: string | null
          district_mn?: string | null
          email?: string | null
          id?: string
          is_active?: boolean | null
          latitude?: number | null
          logo_url?: string | null
          longitude?: number | null
          name: string
          operating_hours?: Json | null
          phone_number: string
          rating?: number | null
          total_reviews?: number | null
          updated_at?: string | null
          website_url?: string | null
        }
        Update: {
          address?: string
          category_id?: string | null
          cover_image_url?: string | null
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          district?: string | null
          district_mn?: string | null
          email?: string | null
          id?: string
          is_active?: boolean | null
          latitude?: number | null
          logo_url?: string | null
          longitude?: number | null
          name?: string
          operating_hours?: Json | null
          phone_number?: string
          rating?: number | null
          total_reviews?: number | null
          updated_at?: string | null
          website_url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "laboratories_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "laboratory_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      laboratory_categories: {
        Row: {
          color_hex: string | null
          created_at: string | null
          description: string | null
          description_mn: string | null
          icon_name: string | null
          id: string
          is_active: boolean | null
          name: string
          name_mn: string | null
          sort_order: number | null
          updated_at: string | null
        }
        Insert: {
          color_hex?: string | null
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          icon_name?: string | null
          id?: string
          is_active?: boolean | null
          name: string
          name_mn?: string | null
          sort_order?: number | null
          updated_at?: string | null
        }
        Update: {
          color_hex?: string | null
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          icon_name?: string | null
          id?: string
          is_active?: boolean | null
          name?: string
          name_mn?: string | null
          sort_order?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      laboratory_services: {
        Row: {
          created_at: string | null
          estimated_duration_hours: number | null
          id: string
          is_available: boolean | null
          laboratory_id: string
          notes: string | null
          price_mnt: number
          service_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          estimated_duration_hours?: number | null
          id?: string
          is_available?: boolean | null
          laboratory_id: string
          notes?: string | null
          price_mnt: number
          service_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          estimated_duration_hours?: number | null
          id?: string
          is_available?: boolean | null
          laboratory_id?: string
          notes?: string | null
          price_mnt?: number
          service_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "laboratory_services_laboratory_id_fkey"
            columns: ["laboratory_id"]
            isOneToOne: false
            referencedRelation: "laboratories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "laboratory_services_service_id_fkey"
            columns: ["service_id"]
            isOneToOne: false
            referencedRelation: "services"
            referencedColumns: ["id"]
          },
        ]
      }
      laboratory_technicians: {
        Row: {
          can_collect_samples: boolean | null
          can_perform_tests: boolean | null
          created_at: string | null
          employment_end_date: string | null
          employment_start_date: string | null
          id: string
          is_active: boolean | null
          is_primary_technician: boolean | null
          laboratory_id: string
          notes: string | null
          technician_id: string
          updated_at: string | null
        }
        Insert: {
          can_collect_samples?: boolean | null
          can_perform_tests?: boolean | null
          created_at?: string | null
          employment_end_date?: string | null
          employment_start_date?: string | null
          id?: string
          is_active?: boolean | null
          is_primary_technician?: boolean | null
          laboratory_id: string
          notes?: string | null
          technician_id: string
          updated_at?: string | null
        }
        Update: {
          can_collect_samples?: boolean | null
          can_perform_tests?: boolean | null
          created_at?: string | null
          employment_end_date?: string | null
          employment_start_date?: string | null
          id?: string
          is_active?: boolean | null
          is_primary_technician?: boolean | null
          laboratory_id?: string
          notes?: string | null
          technician_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "laboratory_technicians_laboratory_id_fkey"
            columns: ["laboratory_id"]
            isOneToOne: false
            referencedRelation: "laboratories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "laboratory_technicians_technician_id_fkey"
            columns: ["technician_id"]
            isOneToOne: false
            referencedRelation: "doctor_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      manual_payment_status_history: {
        Row: {
          changed_by: string
          created_at: string
          id: string
          manual_payment_id: string
          metadata: Json
          new_status: string
          old_status: string | null
          reason: string | null
        }
        Insert: {
          changed_by: string
          created_at?: string
          id?: string
          manual_payment_id: string
          metadata?: Json
          new_status: string
          old_status?: string | null
          reason?: string | null
        }
        Update: {
          changed_by?: string
          created_at?: string
          id?: string
          manual_payment_id?: string
          metadata?: Json
          new_status?: string
          old_status?: string | null
          reason?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "manual_payment_status_history_changed_by_fkey"
            columns: ["changed_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "manual_payment_status_history_manual_payment_id_fkey"
            columns: ["manual_payment_id"]
            isOneToOne: false
            referencedRelation: "manual_payments"
            referencedColumns: ["id"]
          },
        ]
      }
      manual_payments: {
        Row: {
          amount_mnt: number
          created_at: string
          id: string
          patient_id: string
          proof_file_path: string | null
          proof_submitted_at: string | null
          provider_bank_account_id: string
          provider_profile_id: string
          rejection_reason: string | null
          status: string
          test_request_id: string
          transfer_reference: string | null
          updated_at: string
          verified_at: string | null
          verified_by: string | null
        }
        Insert: {
          amount_mnt: number
          created_at?: string
          id?: string
          patient_id: string
          proof_file_path?: string | null
          proof_submitted_at?: string | null
          provider_bank_account_id: string
          provider_profile_id: string
          rejection_reason?: string | null
          status: string
          test_request_id: string
          transfer_reference?: string | null
          updated_at?: string
          verified_at?: string | null
          verified_by?: string | null
        }
        Update: {
          amount_mnt?: number
          created_at?: string
          id?: string
          patient_id?: string
          proof_file_path?: string | null
          proof_submitted_at?: string | null
          provider_bank_account_id?: string
          provider_profile_id?: string
          rejection_reason?: string | null
          status?: string
          test_request_id?: string
          transfer_reference?: string | null
          updated_at?: string
          verified_at?: string | null
          verified_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "manual_payments_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "manual_payments_provider_bank_account_id_fkey"
            columns: ["provider_bank_account_id"]
            isOneToOne: false
            referencedRelation: "provider_bank_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "manual_payments_provider_profile_id_fkey"
            columns: ["provider_profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "manual_payments_test_request_id_fkey"
            columns: ["test_request_id"]
            isOneToOne: true
            referencedRelation: "test_requests"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "manual_payments_verified_by_fkey"
            columns: ["verified_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      notification_preferences: {
        Row: {
          created_at: string | null
          id: string
          push_enabled: boolean | null
          quiet_hours_enabled: boolean | null
          quiet_hours_end: string | null
          quiet_hours_start: string | null
          request_accepted_enabled: boolean | null
          request_created_enabled: boolean | null
          request_updated_enabled: boolean | null
          status_changed_enabled: boolean | null
          system_alert_enabled: boolean | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          push_enabled?: boolean | null
          quiet_hours_enabled?: boolean | null
          quiet_hours_end?: string | null
          quiet_hours_start?: string | null
          request_accepted_enabled?: boolean | null
          request_created_enabled?: boolean | null
          request_updated_enabled?: boolean | null
          status_changed_enabled?: boolean | null
          system_alert_enabled?: boolean | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          push_enabled?: boolean | null
          quiet_hours_enabled?: boolean | null
          quiet_hours_end?: string | null
          quiet_hours_start?: string | null
          request_accepted_enabled?: boolean | null
          request_created_enabled?: boolean | null
          request_updated_enabled?: boolean | null
          status_changed_enabled?: boolean | null
          system_alert_enabled?: boolean | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "notification_preferences_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          created_at: string | null
          id: string
          is_read: boolean | null
          message: string
          message_mn: string | null
          metadata: Json | null
          read_at: string | null
          related_request_id: string | null
          title: string
          title_mn: string | null
          type: Database["public"]["Enums"]["notification_type"]
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          message: string
          message_mn?: string | null
          metadata?: Json | null
          read_at?: string | null
          related_request_id?: string | null
          title: string
          title_mn?: string | null
          type: Database["public"]["Enums"]["notification_type"]
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          message?: string
          message_mn?: string | null
          metadata?: Json | null
          read_at?: string | null
          related_request_id?: string | null
          title?: string
          title_mn?: string | null
          type?: Database["public"]["Enums"]["notification_type"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "notifications_related_request_id_fkey"
            columns: ["related_request_id"]
            isOneToOne: false
            referencedRelation: "test_requests"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notifications_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      patient_addresses: {
        Row: {
          additional_info: string | null
          address_line: string
          apartment_number: string | null
          building_name: string | null
          created_at: string | null
          door_number: string | null
          entrance: string | null
          floor: string | null
          id: string
          is_default: boolean | null
          label: string | null
          latitude: number
          longitude: number
          updated_at: string | null
          user_id: string
        }
        Insert: {
          additional_info?: string | null
          address_line: string
          apartment_number?: string | null
          building_name?: string | null
          created_at?: string | null
          door_number?: string | null
          entrance?: string | null
          floor?: string | null
          id?: string
          is_default?: boolean | null
          label?: string | null
          latitude: number
          longitude: number
          updated_at?: string | null
          user_id: string
        }
        Update: {
          additional_info?: string | null
          address_line?: string
          apartment_number?: string | null
          building_name?: string | null
          created_at?: string | null
          door_number?: string | null
          entrance?: string | null
          floor?: string | null
          id?: string
          is_default?: boolean | null
          label?: string | null
          latitude?: number
          longitude?: number
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "patient_addresses_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      post_categories: {
        Row: {
          color_hex: string | null
          created_at: string | null
          description: string | null
          icon_name: string | null
          id: string
          is_active: boolean | null
          name: string
          name_mn: string | null
          sort_order: number | null
          updated_at: string | null
        }
        Insert: {
          color_hex?: string | null
          created_at?: string | null
          description?: string | null
          icon_name?: string | null
          id?: string
          is_active?: boolean | null
          name: string
          name_mn?: string | null
          sort_order?: number | null
          updated_at?: string | null
        }
        Update: {
          color_hex?: string | null
          created_at?: string | null
          description?: string | null
          icon_name?: string | null
          id?: string
          is_active?: boolean | null
          name?: string
          name_mn?: string | null
          sort_order?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      post_comments: {
        Row: {
          comment_text: string
          created_at: string | null
          id: string
          is_approved: boolean | null
          is_visible: boolean | null
          parent_comment_id: string | null
          post_id: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          comment_text: string
          created_at?: string | null
          id?: string
          is_approved?: boolean | null
          is_visible?: boolean | null
          parent_comment_id?: string | null
          post_id: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          comment_text?: string
          created_at?: string | null
          id?: string
          is_approved?: boolean | null
          is_visible?: boolean | null
          parent_comment_id?: string | null
          post_id?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "post_comments_parent_comment_id_fkey"
            columns: ["parent_comment_id"]
            isOneToOne: false
            referencedRelation: "post_comments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "post_comments_post_id_fkey"
            columns: ["post_id"]
            isOneToOne: false
            referencedRelation: "posts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "post_comments_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      post_likes: {
        Row: {
          created_at: string | null
          id: string
          post_id: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          post_id: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          post_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "post_likes_post_id_fkey"
            columns: ["post_id"]
            isOneToOne: false
            referencedRelation: "posts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "post_likes_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      posts: {
        Row: {
          author_id: string
          category_id: string | null
          content: string
          content_mn: string | null
          created_at: string | null
          excerpt: string | null
          excerpt_mn: string | null
          featured_image_url: string | null
          id: string
          is_featured: boolean | null
          is_published: boolean | null
          like_count: number | null
          media_urls: string[] | null
          meta_description: string | null
          post_type: string
          published_at: string | null
          scheduled_publish_at: string | null
          share_count: number | null
          slug: string | null
          tags: string[] | null
          target_audience: string | null
          target_regions: string[] | null
          title: string
          title_mn: string | null
          updated_at: string | null
          view_count: number | null
        }
        Insert: {
          author_id: string
          category_id?: string | null
          content: string
          content_mn?: string | null
          created_at?: string | null
          excerpt?: string | null
          excerpt_mn?: string | null
          featured_image_url?: string | null
          id?: string
          is_featured?: boolean | null
          is_published?: boolean | null
          like_count?: number | null
          media_urls?: string[] | null
          meta_description?: string | null
          post_type?: string
          published_at?: string | null
          scheduled_publish_at?: string | null
          share_count?: number | null
          slug?: string | null
          tags?: string[] | null
          target_audience?: string | null
          target_regions?: string[] | null
          title: string
          title_mn?: string | null
          updated_at?: string | null
          view_count?: number | null
        }
        Update: {
          author_id?: string
          category_id?: string | null
          content?: string
          content_mn?: string | null
          created_at?: string | null
          excerpt?: string | null
          excerpt_mn?: string | null
          featured_image_url?: string | null
          id?: string
          is_featured?: boolean | null
          is_published?: boolean | null
          like_count?: number | null
          media_urls?: string[] | null
          meta_description?: string | null
          post_type?: string
          published_at?: string | null
          scheduled_publish_at?: string | null
          share_count?: number | null
          slug?: string | null
          tags?: string[] | null
          target_audience?: string | null
          target_regions?: string[] | null
          title?: string
          title_mn?: string | null
          updated_at?: string | null
          view_count?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "posts_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "posts_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "post_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          age: number | null
          allergies: string | null
          avatar_url: string | null
          created_at: string | null
          email: string | null
          fcm_token: string | null
          fcm_token_updated_at: string | null
          first_name: string | null
          full_name: string | null
          gender: string | null
          id: string
          is_active: boolean | null
          is_foreign_citizen: boolean | null
          is_mongolian_citizen: boolean | null
          is_verified: boolean | null
          last_name: string | null
          passport_number: string | null
          permanent_address: string | null
          phone_number: string
          registration_number: string | null
          role: Database["public"]["Enums"]["user_role"]
          updated_at: string | null
        }
        Insert: {
          age?: number | null
          allergies?: string | null
          avatar_url?: string | null
          created_at?: string | null
          email?: string | null
          fcm_token?: string | null
          fcm_token_updated_at?: string | null
          first_name?: string | null
          full_name?: string | null
          gender?: string | null
          id: string
          is_active?: boolean | null
          is_foreign_citizen?: boolean | null
          is_mongolian_citizen?: boolean | null
          is_verified?: boolean | null
          last_name?: string | null
          passport_number?: string | null
          permanent_address?: string | null
          phone_number: string
          registration_number?: string | null
          role?: Database["public"]["Enums"]["user_role"]
          updated_at?: string | null
        }
        Update: {
          age?: number | null
          allergies?: string | null
          avatar_url?: string | null
          created_at?: string | null
          email?: string | null
          fcm_token?: string | null
          fcm_token_updated_at?: string | null
          first_name?: string | null
          full_name?: string | null
          gender?: string | null
          id?: string
          is_active?: boolean | null
          is_foreign_citizen?: boolean | null
          is_mongolian_citizen?: boolean | null
          is_verified?: boolean | null
          last_name?: string | null
          passport_number?: string | null
          permanent_address?: string | null
          phone_number?: string
          registration_number?: string | null
          role?: Database["public"]["Enums"]["user_role"]
          updated_at?: string | null
        }
        Relationships: []
      }
      provider_bank_accounts: {
        Row: {
          account_number: string
          bank_name: string
          branch_name: string | null
          created_at: string
          holder_name: string
          iban: string | null
          id: string
          is_active: boolean
          is_primary: boolean
          provider_profile_id: string
          updated_at: string
        }
        Insert: {
          account_number: string
          bank_name: string
          branch_name?: string | null
          created_at?: string
          holder_name: string
          iban?: string | null
          id?: string
          is_active?: boolean
          is_primary?: boolean
          provider_profile_id: string
          updated_at?: string
        }
        Update: {
          account_number?: string
          bank_name?: string
          branch_name?: string | null
          created_at?: string
          holder_name?: string
          iban?: string | null
          id?: string
          is_active?: boolean
          is_primary?: boolean
          provider_profile_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "provider_bank_accounts_provider_profile_id_fkey"
            columns: ["provider_profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      qpay_payments: {
        Row: {
          amount_mnt: number
          created_at: string
          deeplinks: Json
          id: string
          metadata: Json
          paid_at: string | null
          patient_id: string
          qpay_invoice_id: string | null
          qpay_payment_id: string | null
          qr_image: string | null
          qr_text: string | null
          sender_invoice_no: string
          short_url: string | null
          status: string
          test_request_id: string
          updated_at: string
        }
        Insert: {
          amount_mnt: number
          created_at?: string
          deeplinks?: Json
          id?: string
          metadata?: Json
          paid_at?: string | null
          patient_id: string
          qpay_invoice_id?: string | null
          qpay_payment_id?: string | null
          qr_image?: string | null
          qr_text?: string | null
          sender_invoice_no: string
          short_url?: string | null
          status: string
          test_request_id: string
          updated_at?: string
        }
        Update: {
          amount_mnt?: number
          created_at?: string
          deeplinks?: Json
          id?: string
          metadata?: Json
          paid_at?: string | null
          patient_id?: string
          qpay_invoice_id?: string | null
          qpay_payment_id?: string | null
          qr_image?: string | null
          qr_text?: string | null
          sender_invoice_no?: string
          short_url?: string | null
          status?: string
          test_request_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "qpay_payments_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "qpay_payments_test_request_id_fkey"
            columns: ["test_request_id"]
            isOneToOne: false
            referencedRelation: "test_requests"
            referencedColumns: ["id"]
          },
        ]
      }
      qpay_tokens: {
        Row: {
          access_token: string | null
          expires_at: string | null
          id: boolean
          lock_until: string | null
          refresh_expires_at: string | null
          refresh_token: string | null
          updated_at: string
        }
        Insert: {
          access_token?: string | null
          expires_at?: string | null
          id?: boolean
          lock_until?: string | null
          refresh_expires_at?: string | null
          refresh_token?: string | null
          updated_at?: string
        }
        Update: {
          access_token?: string | null
          expires_at?: string | null
          id?: boolean
          lock_until?: string | null
          refresh_expires_at?: string | null
          refresh_token?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      request_status_history: {
        Row: {
          change_reason: string | null
          changed_by: string | null
          created_at: string | null
          id: string
          metadata: Json | null
          new_status: Database["public"]["Enums"]["request_status"]
          old_status: Database["public"]["Enums"]["request_status"] | null
          request_id: string
        }
        Insert: {
          change_reason?: string | null
          changed_by?: string | null
          created_at?: string | null
          id?: string
          metadata?: Json | null
          new_status: Database["public"]["Enums"]["request_status"]
          old_status?: Database["public"]["Enums"]["request_status"] | null
          request_id: string
        }
        Update: {
          change_reason?: string | null
          changed_by?: string | null
          created_at?: string | null
          id?: string
          metadata?: Json | null
          new_status?: Database["public"]["Enums"]["request_status"]
          old_status?: Database["public"]["Enums"]["request_status"] | null
          request_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "request_status_history_changed_by_fkey"
            columns: ["changed_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "request_status_history_request_id_fkey"
            columns: ["request_id"]
            isOneToOne: false
            referencedRelation: "test_requests"
            referencedColumns: ["id"]
          },
        ]
      }
      service_categories: {
        Row: {
          created_at: string | null
          description: string | null
          icon_name: string | null
          id: string
          name: string
          name_mn: string | null
          type: Database["public"]["Enums"]["service_category_type"]
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          icon_name?: string | null
          id?: string
          name: string
          name_mn?: string | null
          type: Database["public"]["Enums"]["service_category_type"]
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          icon_name?: string | null
          id?: string
          name?: string
          name_mn?: string | null
          type?: Database["public"]["Enums"]["service_category_type"]
          updated_at?: string | null
        }
        Relationships: []
      }
      services: {
        Row: {
          category_id: string
          created_at: string | null
          description: string | null
          description_mn: string | null
          equipment_needed: string | null
          estimated_duration_minutes: number | null
          id: string
          is_active: boolean | null
          name: string
          name_mn: string | null
          preparation_instructions: string | null
          sample_type: string | null
          updated_at: string | null
        }
        Insert: {
          category_id: string
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          equipment_needed?: string | null
          estimated_duration_minutes?: number | null
          id?: string
          is_active?: boolean | null
          name: string
          name_mn?: string | null
          preparation_instructions?: string | null
          sample_type?: string | null
          updated_at?: string | null
        }
        Update: {
          category_id?: string
          created_at?: string | null
          description?: string | null
          description_mn?: string | null
          equipment_needed?: string | null
          estimated_duration_minutes?: number | null
          id?: string
          is_active?: boolean | null
          name?: string
          name_mn?: string | null
          preparation_instructions?: string | null
          sample_type?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "services_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "service_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      test_requests: {
        Row: {
          accepted_at: string | null
          cancellation_reason: string | null
          cancelled_at: string | null
          cancelled_by: string | null
          completed_at: string | null
          created_at: string | null
          delivered_to_lab_at: string | null
          doctor_commission_mnt: number | null
          doctor_id: string | null
          doctor_service_id: string | null
          id: string
          laboratory_id: string | null
          laboratory_service_id: string | null
          on_the_way_at: string | null
          patient_address: string
          patient_id: string
          patient_latitude: number | null
          patient_longitude: number | null
          patient_notes: string | null
          payment_status: string | null
          price_mnt: number
          request_type: Database["public"]["Enums"]["request_type"] | null
          sample_collected_at: string | null
          scheduled_date: string
          scheduled_time_slot: string | null
          service_id: string | null
          status: Database["public"]["Enums"]["request_status"]
          updated_at: string | null
        }
        Insert: {
          accepted_at?: string | null
          cancellation_reason?: string | null
          cancelled_at?: string | null
          cancelled_by?: string | null
          completed_at?: string | null
          created_at?: string | null
          delivered_to_lab_at?: string | null
          doctor_commission_mnt?: number | null
          doctor_id?: string | null
          doctor_service_id?: string | null
          id?: string
          laboratory_id?: string | null
          laboratory_service_id?: string | null
          on_the_way_at?: string | null
          patient_address: string
          patient_id: string
          patient_latitude?: number | null
          patient_longitude?: number | null
          patient_notes?: string | null
          payment_status?: string | null
          price_mnt: number
          request_type?: Database["public"]["Enums"]["request_type"] | null
          sample_collected_at?: string | null
          scheduled_date: string
          scheduled_time_slot?: string | null
          service_id?: string | null
          status?: Database["public"]["Enums"]["request_status"]
          updated_at?: string | null
        }
        Update: {
          accepted_at?: string | null
          cancellation_reason?: string | null
          cancelled_at?: string | null
          cancelled_by?: string | null
          completed_at?: string | null
          created_at?: string | null
          delivered_to_lab_at?: string | null
          doctor_commission_mnt?: number | null
          doctor_id?: string | null
          doctor_service_id?: string | null
          id?: string
          laboratory_id?: string | null
          laboratory_service_id?: string | null
          on_the_way_at?: string | null
          patient_address?: string
          patient_id?: string
          patient_latitude?: number | null
          patient_longitude?: number | null
          patient_notes?: string | null
          payment_status?: string | null
          price_mnt?: number
          request_type?: Database["public"]["Enums"]["request_type"] | null
          sample_collected_at?: string | null
          scheduled_date?: string
          scheduled_time_slot?: string | null
          service_id?: string | null
          status?: Database["public"]["Enums"]["request_status"]
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "test_requests_cancelled_by_fkey"
            columns: ["cancelled_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_doctor_id_fkey"
            columns: ["doctor_id"]
            isOneToOne: false
            referencedRelation: "doctor_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_doctor_service_id_fkey"
            columns: ["doctor_service_id"]
            isOneToOne: false
            referencedRelation: "doctor_services"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_laboratory_id_fkey"
            columns: ["laboratory_id"]
            isOneToOne: false
            referencedRelation: "laboratories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_laboratory_service_id_fkey"
            columns: ["laboratory_service_id"]
            isOneToOne: false
            referencedRelation: "laboratory_services"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_requests_service_id_fkey"
            columns: ["service_id"]
            isOneToOne: false
            referencedRelation: "services"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      admin_dashboard_stats: {
        Row: {
          accepted_requests: number | null
          cancelled_requests: number | null
          completed_requests: number | null
          pending_requests: number | null
          total_doctors: number | null
          total_laboratories: number | null
          total_nurses: number | null
          total_patients: number | null
          total_requests: number | null
          total_services: number | null
          total_tests: number | null
        }
        Relationships: []
      }
    }
    Functions: {
      accept_test_request: {
        Args: { p_request_id: string }
        Returns: {
          accepted_at: string | null
          cancellation_reason: string | null
          cancelled_at: string | null
          cancelled_by: string | null
          completed_at: string | null
          created_at: string | null
          delivered_to_lab_at: string | null
          doctor_commission_mnt: number | null
          doctor_id: string | null
          doctor_service_id: string | null
          id: string
          laboratory_id: string | null
          laboratory_service_id: string | null
          on_the_way_at: string | null
          patient_address: string
          patient_id: string
          patient_latitude: number | null
          patient_longitude: number | null
          patient_notes: string | null
          payment_status: string | null
          price_mnt: number
          request_type: Database["public"]["Enums"]["request_type"] | null
          sample_collected_at: string | null
          scheduled_date: string
          scheduled_time_slot: string | null
          service_id: string | null
          status: Database["public"]["Enums"]["request_status"]
          updated_at: string | null
        }
        SetofOptions: {
          from: "*"
          to: "test_requests"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      attach_qpay_invoice_data: {
        Args: {
          p_deeplinks: Json
          p_local_id: string
          p_qpay_invoice_id: string
          p_qr_image: string
          p_qr_text: string
          p_short_url: string
        }
        Returns: boolean
      }
      can_patient_review_doctor: {
        Args: {
          p_doctor_id: string
          p_patient_id: string
          p_test_request_id: string
        }
        Returns: boolean
      }
      create_manual_payment_for_request: {
        Args: { p_provider_profile_id?: string; p_request_id: string }
        Returns: string
      }
      create_notification: {
        Args: {
          p_message: string
          p_metadata?: Json
          p_request_id?: string
          p_title: string
          p_type: Database["public"]["Enums"]["notification_type"]
          p_user_id: string
        }
        Returns: string
      }
      delete_old_notifications: {
        Args: { p_days_old?: number }
        Returns: number
      }
      generate_post_slug: {
        Args: { p_post_id: string; p_title: string }
        Returns: string
      }
      get_admin_dashboard_stats: { Args: never; Returns: Json }
      get_admin_monthly_stats: {
        Args: { p_months?: number }
        Returns: {
          month: string
          requests_completed: number
          requests_created: number
          revenue_mnt: number
        }[]
      }
      get_admin_payment_history: {
        Args: { p_limit?: number; p_offset?: number }
        Returns: {
          amount_mnt: number
          created_at: string
          paid_at: string
          patient_id: string
          patient_name: string
          payment_id: string
          source: string
          status: string
          test_request_id: string
        }[]
      }
      get_all_requests_admin: {
        Args: never
        Returns: {
          created_at: string
          doctor_name: string
          doctor_phone: string
          id: string
          laboratory_name: string
          patient_name: string
          patient_phone: string
          price_mnt: number
          request_type: Database["public"]["Enums"]["request_type"]
          scheduled_date: string
          scheduled_time_slot: string
          service_name: string
          status: Database["public"]["Enums"]["request_status"]
          updated_at: string
        }[]
      }
      get_all_users_admin: {
        Args: never
        Returns: {
          age: number
          created_at: string
          doctor_type: Database["public"]["Enums"]["doctor_type"]
          email: string
          first_name: string
          full_name: string
          gender: string
          id: string
          is_active: boolean
          is_verified: boolean
          last_name: string
          license_number: string
          phone_number: string
          profession: string
          rating: number
          role: Database["public"]["Enums"]["user_role"]
          total_completed_requests: number
        }[]
      }
      get_available_doctors: {
        Args: { p_scheduled_date?: string; p_scheduled_time?: string }
        Returns: {
          avatar_url: string
          doctor_type: Database["public"]["Enums"]["doctor_type"]
          full_name: string
          gender: string
          id: string
          is_available: boolean
          phone_number: string
          profession: string
          rating: number
          total_completed_requests: number
          total_reviews: number
        }[]
      }
      get_daily_request_stats: {
        Args: { days_back?: number }
        Returns: {
          accepted_count: number
          cancelled_count: number
          completed_count: number
          pending_count: number
          request_date: string
          total_requests: number
        }[]
      }
      get_direct_services: {
        Args: never
        Returns: {
          category_description: string
          category_icon_name: string
          category_id: string
          category_name: string
          category_name_mn: string
          category_type: string
          doctor_count: number
          equipment_needed: string
          estimated_duration_minutes: number
          max_price: number
          min_price: number
          preparation_instructions: string
          service_description: string
          service_description_mn: string
          service_id: string
          service_name: string
          service_name_mn: string
        }[]
      }
      get_doctor_reviews: {
        Args: { p_doctor_id: string; p_limit?: number; p_offset?: number }
        Returns: {
          communication_rating: number
          created_at: string
          doctor_response: string
          helpful_count: number
          patient_avatar_url: string
          patient_name: string
          professionalism_rating: number
          punctuality_rating: number
          rating: number
          responded_at: string
          review_id: string
          review_text: string
          review_title: string
        }[]
      }
      get_doctors_for_service: {
        Args: { p_service_id: string }
        Returns: {
          avatar_url: string
          doctor_type: Database["public"]["Enums"]["doctor_type"]
          full_name: string
          gender: string
          id: string
          is_available: boolean
          phone_number: string
          price_mnt: number
          profession: string
          rating: number
          total_completed_requests: number
          total_reviews: number
        }[]
      }
      get_laboratory_services: {
        Args: { p_laboratory_id: string }
        Returns: {
          category_name: string
          category_type: Database["public"]["Enums"]["service_category_type"]
          estimated_duration_hours: number
          is_available: boolean
          preparation_instructions: string
          price_mnt: number
          sample_type: string
          service_description: string
          service_id: string
          service_name: string
        }[]
      }
      get_laboratory_technicians: {
        Args: { p_laboratory_id: string }
        Returns: {
          avatar_url: string
          can_collect_samples: boolean
          can_perform_tests: boolean
          full_name: string
          gender: string
          is_primary_technician: boolean
          license_number: string
          phone_number: string
          profession: string
          rating: number
          technician_id: string
          total_completed_requests: number
        }[]
      }
      get_pending_direct_requests_for_doctor: {
        Args: never
        Returns: {
          category_name: string
          created_at: string
          patient_address: string
          patient_id: string
          patient_latitude: number
          patient_longitude: number
          patient_name: string
          patient_phone: string
          price_mnt: number
          request_id: string
          scheduled_date: string
          scheduled_time_slot: string
          service_name: string
        }[]
      }
      get_pending_lab_requests: {
        Args: { p_laboratory_id: string }
        Returns: {
          created_at: string
          patient_address: string
          patient_id: string
          patient_name: string
          patient_phone: string
          price_mnt: number
          request_id: string
          scheduled_date: string
          scheduled_time_slot: string
          service_name: string
        }[]
      }
      get_pending_requests_for_doctor: {
        Args: never
        Returns: {
          created_at: string
          id: string
          patient_address: string
          patient_id: string
          patient_latitude: number
          patient_longitude: number
          patient_name: string
          patient_phone: string
          price_mnt: number
          scheduled_date: string
          scheduled_time_slot: string
          test_type_name: string
        }[]
      }
      get_published_posts: {
        Args: {
          p_category_id?: string
          p_limit?: number
          p_offset?: number
          p_post_type?: string
        }
        Returns: {
          author_avatar_url: string
          author_name: string
          category_name: string
          excerpt: string
          excerpt_mn: string
          featured_image_url: string
          is_featured: boolean
          like_count: number
          post_id: string
          post_type: string
          published_at: string
          slug: string
          title: string
          title_mn: string
          view_count: number
        }[]
      }
      get_unread_notification_count: {
        Args: { p_user_id: string }
        Returns: number
      }
      get_user_role: {
        Args: never
        Returns: Database["public"]["Enums"]["user_role"]
      }
      get_users_for_push_notification: {
        Args: {
          p_notification_type: Database["public"]["Enums"]["notification_type"]
        }
        Returns: {
          fcm_token: string
          message: string
          notification_id: string
          title: string
          user_id: string
        }[]
      }
      increment: {
        Args: { column_name: string; row_id: string; table_name: string }
        Returns: undefined
      }
      is_admin: { Args: never; Returns: boolean }
      is_doctor: { Args: never; Returns: boolean }
      is_doctor_active_and_verified: {
        Args: { doctor_id: string }
        Returns: boolean
      }
      is_patient: { Args: never; Returns: boolean }
      is_verified_doctor: { Args: never; Returns: boolean }
      mark_all_notifications_read: {
        Args: { p_user_id: string }
        Returns: number
      }
      mark_notification_as_sent: {
        Args: { p_notification_id: string }
        Returns: undefined
      }
      mark_qpay_payment_paid: {
        Args: {
          p_amount_mnt: number
          p_local_id: string
          p_metadata?: Json
          p_qpay_payment_id: string
        }
        Returns: boolean
      }
      mark_qpay_payment_status: {
        Args: { p_local_id: string; p_metadata?: Json; p_status: string }
        Returns: boolean
      }
      qpay_acquire_token: {
        Args: { p_buffer_seconds?: number; p_lease_seconds?: number }
        Returns: {
          access_token: string
          expires_at: string
          lease_acquired: boolean
          needs_refresh: boolean
          refresh_expires_at: string
          refresh_token: string
        }[]
      }
      qpay_persist_token: {
        Args: {
          p_access_token: string
          p_expires_at: string
          p_refresh_expires_at: string
          p_refresh_token: string
        }
        Returns: undefined
      }
      reject_manual_payment: {
        Args: { p_manual_payment_id: string; p_reason: string }
        Returns: boolean
      }
      reserve_qpay_invoice_slot: {
        Args: {
          p_amount_mnt: number
          p_local_id: string
          p_patient_id: string
          p_request_id: string
          p_sender_invoice_no: string
        }
        Returns: string
      }
      search_services: {
        Args: { p_search_term: string }
        Returns: {
          category_name: string
          category_type: Database["public"]["Enums"]["service_category_type"]
          service_description: string
          service_id: string
          service_name: string
          service_type: string
        }[]
      }
      submit_manual_payment_proof: {
        Args: {
          p_manual_payment_id: string
          p_proof_file_path?: string
          p_transfer_reference?: string
        }
        Returns: boolean
      }
      update_fcm_token: {
        Args: { p_fcm_token: string; p_user_id: string }
        Returns: undefined
      }
      verify_manual_payment: {
        Args: { p_manual_payment_id: string }
        Returns: boolean
      }
    }
    Enums: {
      availability_day:
        | "monday"
        | "tuesday"
        | "wednesday"
        | "thursday"
        | "friday"
        | "saturday"
        | "sunday"
      doctor_type:
        | "lab_technician"
        | "diagnostic_specialist"
        | "nurse"
        | "general"
      notification_type:
        | "request_created"
        | "request_accepted"
        | "request_updated"
        | "status_changed"
        | "system_alert"
      payment_method: "qpay" | "cash" | "card" | "bank_transfer"
      payment_status:
        | "pending"
        | "processing"
        | "completed"
        | "failed"
        | "refunded"
        | "cancelled"
      request_status:
        | "pending"
        | "accepted"
        | "on_the_way"
        | "sample_collected"
        | "delivered_to_lab"
        | "completed"
        | "cancelled"
      request_type: "lab_service" | "direct_service"
      service_category_type:
        | "lab_test"
        | "diagnostic_procedure"
        | "nursing_care"
      user_role: "patient" | "doctor" | "admin"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      availability_day: [
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
      ],
      doctor_type: [
        "lab_technician",
        "diagnostic_specialist",
        "nurse",
        "general",
      ],
      notification_type: [
        "request_created",
        "request_accepted",
        "request_updated",
        "status_changed",
        "system_alert",
      ],
      payment_method: ["qpay", "cash", "card", "bank_transfer"],
      payment_status: [
        "pending",
        "processing",
        "completed",
        "failed",
        "refunded",
        "cancelled",
      ],
      request_status: [
        "pending",
        "accepted",
        "on_the_way",
        "sample_collected",
        "delivered_to_lab",
        "completed",
        "cancelled",
      ],
      request_type: ["lab_service", "direct_service"],
      service_category_type: [
        "lab_test",
        "diagnostic_procedure",
        "nursing_care",
      ],
      user_role: ["patient", "doctor", "admin"],
    },
  },
} as const
