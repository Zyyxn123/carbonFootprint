

export interface Type {
  val: boolean
}

export interface Location {
  latitude: number;
  longitude: number;
}

export interface Viewport {
  northeast: Location;
  southwest: Location;
}

export interface City {
  cityCode: string;
  cityId: string;
  cityName: string;
}

export interface StreetNumber {
  streetNumber: string;
  streetName: string;
}

export interface AddressComponent {
  countryName: string;
  countryCode: string;
  adminLevel1: string;
  adminLevel2: string;
  adminLevel3: string;
  adminLevel4: string;
  adminCode: string;
  city: City;
  streetNumber: StreetNumber;
}

export interface TimePoint {
  week: number;
  time: string;
}

export interface OpeningPeriod {
  open: TimePoint;
  close: TimePoint;
}

export interface OpeningHours {
  texts: string[];
  periods: OpeningPeriod[];
}

export interface PoiComment {
  averageRating: number;
  total?: number;
}

export interface PoiInfo {
  poiTypes: string[];
  poiTypeIds: string[];
  phone: string;
  internationalPhone: string;
  rating: number;
  openingHours: Partial<OpeningHours>;
  businessStatus: string;
  brand?: string;
  starRating: number;
  icon: string;
  comment: PoiComment;
}

export interface SiteItem {
  siteId: string;
  name?: string;
  formatAddress?: string;
  addressComponent?: AddressComponent;
  location?: Location;
  viewport?: Viewport;
  distance: number;
  poi?: PoiInfo;
}

export interface SiteSearchResponse {
  totalCount: number;
  sites: SiteItem[];
}

export interface PointAnnotationData {
  id: number;
  latitude: number;
  longitude: number;
  title: string;
  description: string;
  iconColor?: string;
}